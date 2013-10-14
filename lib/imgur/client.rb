class Imgur::Client < Cistern::Service
  @recognized_arguments = [:config]
  model_path "imgur/models"
  request_path "imgur/requests"

  model :image
  collection :images
  request :get_image
  request :get_images
  request :upload_image
  request :delete_image

  model :album
  collection :albums
  request :get_album
  request :get_albums

  model :account
  collection :accounts
  request :get_accounts
  request :get_account

  model :comment
  collection :comments
  request :get_comments
  request :get_comment
  request :add_comment
  request :add_comment_reply

  model :basic_response
  collection :basic_responses

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

      request_body = if body = options[:body]
                       headers.merge!("Content-Type" => "application/json, charset=utf-8", "Content-Length" => body.to_s.size.to_s,)
                       body
                     end
      request_body ||= options[:params] || {}
      path           = "#{path}?#{query.map{|k,v| "#{URI.escape(k.to_s)}=#{URI.escape(v.to_s)}"}.join("&")}" unless query.empty?
      begin
        response = case method
                   when "get"
                     @connection[path].get(headers)
                   when "post"
                     @connection[path].post(request_body, headers)
                   when "delete"
                     @connection[path].delete(headers)
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
    def self.random_id
      characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'
      selection  = ''
      7.times do
        position = rand(characters.length)
        selection << characters[position..position]
      end
      selection
    end

    def self.random_number
      characters = '1234567890'
      selection  = ''
      7.times do
        position = rand(characters.length)
        selection << characters[position..position]
      end
      selection.to_i
    end

    def self.data
      @data ||= begin
                  image_id     = random_id
                  account_id   = random_number
                  account_name = random_id
                  album_id     = random_id
                  comment_id   = random_id

                  account = {
                    "id"         => account_id,
                    "url"        => "#{account_name}.imgur.com",
                    "bio"        => nil,
                    "reputation" => 435.5,
                    "created"    => 1349051610,
                  }

                  image = {
                    "id"         => image_id,
                    "title"      => "test image",
                    "datetime"   => 1349051625,
                    "type"       => "image/jpeg",
                    "animated"   => false,
                    "width"      => 2490,
                    "height"     => 3025,
                    "size"       => 618969,
                    "views"      => 625622,
                    "bandwidth"  => 387240623718,
                    "ups"        => 1889,
                    "downs"      => 58,
                    "score"      => 18935622,
                    "account_id" => account_id,
                  }

                  album = {
                    "id"          => album_id,
                    "title"       => "test album",
                    "description" => nil,
                    "privacy"     => "public",
                    "cover"       => image_id,
                    "order"       => 0,
                    "layout"      => "blog",
                    "datetime"    => 1347058832,
                    "link"        => "https://imgur.com/a/#{album_id}",
                    "account_id"  => account_id,
                  }

                  comment = {
                    "id"        => comment_id,
                    "image_id"  => image_id,
                    "author"    => account_name,
                    "author_id" => account_id,
                    "on_album"  => false,
                    "ups"       => 10,
                    "downs"     => 2,
                    "points"    => 23.4,
                    "datetime"  => 1349051670,
                    "parent_id" => 2,
                    "deleted"   => false,
                    "children"  => [],
                  }

                  {
                    :images   => {image_id   => image},
                    :accounts => {account_id => account},
                    :albums   => {album_id   => album},
                    :comments => {comment_id => comment},
                  }
                end
    end

    def self.reset!
      @data = nil
    end

    def data
      self.class.data
    end

    def random_id
      self.class.random_id
    end

    def credits
      "980/1000"
    end

    def initialize(options={})
      @url = options[:url] || "https://api.imgur.com"
    end

    def response(options={})
      status  = options[:status] || 200
      body    = options[:body]
      headers = {
        "Content-Type" => "application/json; charset=utf-8"
      }.merge(options[:headers] || {})

      Imgur::Response.new(status, headers, body).raise!
    end
  end
end
