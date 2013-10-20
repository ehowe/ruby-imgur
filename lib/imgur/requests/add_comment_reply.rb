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

  class Mock
    def add_comment_reply(data, reply)
      reply = {
          id: random_id,
          image_id: data[:image_id],
          comment: reply,
          author: random_id,
          author_id: random_number,
          on_album: false,
          album_cover: data[:image_id],
          ups: 1,
          downs: 0,
          points: 1,
          datetime: random_number,
          parent_id: data[:comment_id],
          deleted: false,
          children: []
      }

      self.data.comments.values.first.children.push reply

      basic_response = {
          'data'    => true,
          'status'  => 200,
          'success' => true,
      }

      response(body: basic_response)
    end
  end
end
