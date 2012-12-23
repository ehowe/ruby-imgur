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

  class Mock
    def delete_image(deletehash)
      image = self.data[:images].values.detect { |i| i["deletehash"] == deletehash }

      self.data[:images].delete_if do |id, image|
        image["deletehash"] == deletehash
      end

      basic_response = {
        "data"    => true,
        "status"  => 200,
        "success" => true,
      }

      response(body: basic_response)
    end
  end
end
