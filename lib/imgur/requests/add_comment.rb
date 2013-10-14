class Imgur::Client
  class Real
    def add_comment(image_data, comment)
      path = "/gallery/#{image_data[:type]}/#{image_data[:id]}/comment"

      request(
        :method => :post,
        :path   => path,
        :params => {:comment => comment}
      )
    end
  end
end
