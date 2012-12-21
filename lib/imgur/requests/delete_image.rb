class Imgur::Client
  class Real
    def delete_image(deletehash)
      path = "/image/#{deletehash}"

      request(
        :method => :delete,
        :path   => path,
      )
    end
  end
end
