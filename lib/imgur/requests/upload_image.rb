class Imgur::Client
  class Real
    def upload_image(options)
      path = "/upload"

      request(
        :method => :post,
        :path   => path,
        :upload => options.delete(:upload),
        :body   => options,
      )
    end
  end
end
