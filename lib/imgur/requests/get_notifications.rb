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

  class Mock
    def get_notifications
      notifications = self.data[:notifications].values.first
      response(body: {"data" => notifications})
    end
  end
end
