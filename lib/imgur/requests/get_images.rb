class Imgur::Client
  class Real
    def get_images(params={})
      path = params[:path]
      request(
        :method => :get,
        :path   => path,
      )
    end
  end

  class Mock
    def get_images(params={})
      images = self.data[:images].values
      images = if params[:path] =~ /^\/account/
                 {"data" => images.select { |i| !i["account_id"].nil? } }
               else
                 {"data" => images}
               end

      response(body: images)
    end
  end
end
