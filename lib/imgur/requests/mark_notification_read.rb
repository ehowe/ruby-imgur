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
end
