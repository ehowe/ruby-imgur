class Imgur::Client < Cistern::Service
  @recognized_arguments = [:config]
  model_path "imgur/models"
  request_path "imgur/requests"

  model :image
  collection :images
  request :get_image
  request :get_images
  request :upload_image

  model :album
  collection :albums
  request :get_album
  request :get_albums

  model :account
  collection :accounts
  request :get_accounts
  request :get_account

  class Real
    attr_accessor :url, :path, :parser, :logger, :config, :authorize_path, :token_path, :connection

    def initialize(options={})
      @config                          = options[:config] || YAML.load_file(File.expand_path("~/.imgurrc")) || YAML.load_file("config/config.yml")
      @authorize_path                  = "/oauth2/authorize"
      @token_path                      = "/oauth2/token"
      @url                             = URI.parse(options[:url]  || "https://api.imgur.com")
      @logger                          = options[:logger]         || Logger.new(nil)
      @parser                          = begin; require 'json'; JSON; end
      @connection                      = RestClient::Resource.new(@url)
    end

    def reset!
      @config     = nil
      @config     = YAML.load_file(File.expand_path("~/.imgurrc"))
    end

    def refresh_token
      response = RestClient.post(
        @url.to_s + @token_path,
        :client_id     => @config[:client_id],
        :client_secret => @config[:client_secret],
        :refresh_token => @config[:refresh_token],
        :grant_type    => "refresh_token",
      )
      new_params = @parser.load(response)
      @config[:access_token] = new_params["access_token"]
      @config[:refresh_token] = new_params["refresh_token"]
      File.open(File.expand_path("~/.imgurrc"), "w") { |f| YAML.dump(@config, f) }
      self.reset!
      return true
    end

    def request(options={})
      method  = (options[:method] || :get).to_s.downcase
      path    = "/3#{options[:path]}" || "/3"
      query   = options[:query] || {}
      unless @config[:access_token]
        Launchy.open(@url.to_s + @authorize_path + "?client_id=#{@config[:client_id]}&response_type=token")
        puts "Copy and paste access_token from URL here"
        verifier     = $stdin.gets.strip
        puts "Copy and paste refresh_token from URL here"
        refresh_token = $stdin.gets.strip
        @config[:access_token] = verifier
        @config[:refresh_token] = refresh_token
        File.open(File.expand_path("~/.imgurrc"), 'w') { |f| YAML.dump(@config, f) }
      end
      headers = {
        "Accept"        => "application/json",
        "Authorization" => "Bearer #{@config[:access_token]}",
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
      begin
        response = case method
                   when "get"
                     @connection[path].get(headers)
                   when "post"
                     @connection[path].post(image: options[:body][:image])
                   end
      rescue RestClient::Forbidden => e
        self.refresh_token
        retry
      end
      parsed_body    = response.strip.empty? ? {} : parser.load(response)
      status         = parsed_body.delete("status")
      Imgur::Response.new(status, {}, parsed_body).raise!
    end

    def credits
      response = request(
        method: :get,
        path: "/credits"
      ).body["data"]
      "#{response["UserRemaining"]}/#{response["UserLimit"]}"
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
      @url = options[:url] || "https://api.imgur.com"
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
