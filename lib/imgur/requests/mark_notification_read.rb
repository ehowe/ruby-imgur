class Imgur::Client
  class Real
    def mark_notification_read(id)
      path = "/notification/#{id}"

      request(
          :method => :post,
          :path => path,
      )
    end
  end

  class Mock
    def mark_notification_read(id)
      notification = self.data[:notifications].values.first
      notification.viewed = true

      basic_response = {
          :data    => true,
          :status  => 200,
          :success => true,
      }

      response(body: basic_response)
    end
  end
end
