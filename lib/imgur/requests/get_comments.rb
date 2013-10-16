class Imgur::Client
  class Real
    def get_comments(data)
      path = "/gallery/#{data[:type]}/#{data[:id]}/comments/best"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end

  class Mock
    def get_comments(data)
      comments = self.data[:comments].values
      response(body: {'data' => comments})
    end
  end
end
