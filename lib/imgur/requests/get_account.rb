class Imgur::Client
  class Real
    def get_account(id)
      path = "/#{id}"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
