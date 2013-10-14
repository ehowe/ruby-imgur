class Imgur::Client
  class Real
    def get_notifications
      path = '/notification'

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
