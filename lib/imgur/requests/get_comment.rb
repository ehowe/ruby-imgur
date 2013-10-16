class Imgur::Client
  class Real
    def get_comment(id)
      path = "/comment/#{id}"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end

  class Mock
    def get_comment(id)
      comments = self.data[:comments].values

      comments.each do |comment|
        return response(body: {'data' => comment}) if comment.id === id
      end
    end
  end

end
