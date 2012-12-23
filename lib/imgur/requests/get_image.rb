class Imgur::Client
  class Real
    def get_image(id)
      path = "/image/#{id["id"]}"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end

  class Mock
    def get_image(id)
      image = self.data[:images][id["id"]]

      response(:body => {"data" => image})
    end
  end
end
