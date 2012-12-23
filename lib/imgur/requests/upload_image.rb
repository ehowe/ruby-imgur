class Imgur::Client
  class Real
    def upload_image(options={})
      path = "/upload"

      request(
        :method => :post,
        :path   => path,
        :body   => options,
      )
    end
  end

  class Mock
    def upload_image(options={})
      images     = self.data[:images]
      image_id   = self.random_id
      account_id = self.data[:accounts].values.first["id"]

      image = {
        "id"         => image_id,
        "title"      => options[:title],
        "datetime"   => 1349051625,
        "type"       => "image/jpeg",
        "animated"   => false,
        "width"      => 2490,
        "height"     => 3025,
        "size"       => 618969,
        "views"      => 625622,
        "bandwidth"  => 387240623718,
        "ups"        => 1889,
        "downs"      => 58,
        "score"      => 18935622,
        "deletehash" => self.random_id,
      }

      images[image_id] = image

      response(:body => {"data" => image})
    end
  end
end
