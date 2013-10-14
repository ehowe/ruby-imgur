class Imgur::Client
  class Real
    def add_comment_reply(data, reply)
      path = "/gallery/#{data[:image_type]}/#{data[:image_id]}/comment/#{data[:comment_id]}"

      request(
        :method => :post,
        :path   => path,
        :params => {:comment => reply}
      )
    end
  end
end
