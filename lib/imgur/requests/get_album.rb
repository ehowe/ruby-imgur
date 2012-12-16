class Imgur::Client
  class Real
    def get_album(id)
      path = "/album/#{id}"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
