class Imgur::Client
  class Real
    def get_comment(id)
      path = "/comment/#{id}"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
