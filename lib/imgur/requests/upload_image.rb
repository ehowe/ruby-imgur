class Imgur::Client
  class Real
    def upload_image(options)
      path = "/upload"

      request(
        :method => :post,
        :path   => path,
        :body   => options,
      )
    end
  end
end
