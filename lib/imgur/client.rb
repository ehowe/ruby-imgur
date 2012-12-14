class Imgur::Client < Cistern::Service
  model_path "imgur/models"
  request_path "imgur/requests"

  model :image
  collection :images
  request :get_images

  class Real
    attr_reader :url, :path, :connection, :parser, :logger, :adapter, :config, :access_token

    def initialize(options={})
      @config = YAML.load_file("config/config.yml")
      @consumer = OAuth::Consumer.new(@config[:client_id], @config[:client_secret], 
      {
        :site               => "https://api.imgur.com",
        :oauth_version      => "2.0",
        :http_method        => :post,
        :authorize_path     => "/oauth2/authorize",
        :access_token_path  => "/oauth2/token",
      })
      token_hash = { oauth_token: @config[:client_id], oauth_token_secret: @config[:client_secret] }
      @access_token = OAuth::AccessToken.from_hash(@consumer, token_hash)
      @url    = URI.parse(options[:url]  || "https://api.imgur.com/3")
      @logger = options[:logger]         || Logger.new(nil)
      adapter = options[:adapter]        || Rack::Client::Handler::NetHTTP
      @parser = begin; require 'json'; JSON; end

      #@connection = Rack::Client.new(@url.to_s) do
      #  use Rack::Config do |env|
      #    env['HTTP_DATE'] = Time.now.httpdate
      #  end
      #  use Imgur::Logger, logger
      #  run adapter
      #end
    end

    def request(options={})
      method  = (options[:method] || :get).to_s.downcase
      path    = "/3#{options[:path]}" || "/3"
      query   = options[:query] || {}
      headers = {
        "Accept" => "application/json",
      }.merge(options[:headers] || {})

      request_body = if body        = options[:body]
                       json_body    = parser.dump(body)
                       headers      = {
                         "Content-Type"   => "application/json, charset=utf-8",
                         "Content-Length" => json_body.size.to_s,
                       }.merge(options[:headers] || {})

                       json_body
                     end
      request_body ||= options[:params] || {}
      path           = "#{path}?#{query.map{|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.join("&")}" unless query.empty?
      p @access_token
      p path
      response       = @access_token.send(method, path).body
      parsed_body    = response.strip.empty? ? {} : parser.load(response)
      status         = parsed_body.delete("status")
      Imgur::Response.new(status, {}, parsed_body).raise!
    end
  end

  class Mock
    def self.data
      @data ||= {}
    end

    def self.reset!
      @data = nil
    end

    def data
      self.class.data
    end

    def initalize(options={})
      @url = options[:url] || "https://api.imgur.com/3"
    end

    def page(params, collection, object_rool, options={})
      if params["url"]
        uri = URI.parse(params["url"])
        params = uri.query.split("&").inject({}) { |r,e| k,v = e.qplit("="); r.merge(k => v) }
      end

      resources   = options[:resources] || self.data[collection]
      page_size   = (params["per_page"] || 20).to_i
      page_index  = (params["page"] || 1).to_i
      total_pages = (resources.size.to_f / page_size.to_f).round
      offset      = (page_index - 1) * page_size
      links       = []

      resource_page = resources.values.reverse.slice(offset, page_size)

      if page_index < total_pages
        links << url_for_page(collection, page_index - 1, page_size, 'next')
      end

      if page_index - 1 > 0
        links << url_for_page(collection, page_index - 1, page_size, 'prev')
      end

      links << url_for_page(collection, total_pages, page_size, 'last')

      [links.join(", "), resource_page]
    end

    def url_for_page(collection, page_index, page_size, rel)
      "<#{File.join(@url, collection.to_s)}?page=#{page_index}&per_page=#{page_size}>; rel=\"#{rel}\""
    end

    def response(options={})
      status  = options[:status] || 200
      body    = options[:body]
      headers = {
        "Content-Type" => "application/json; charset=utf-8"
      }.merge(options[:headers] || {})

      Imgur::Response.new(status, headers, body).raise!
    end

    def url_for(path)
      File.join(@url, path)
    end

    def stringify_keys(hash)
      hash.inject({}) { |r,(k,v)| r.merge(k.to_s => v) }
    end
  end
end
