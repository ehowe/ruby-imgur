class Imgur::Client
  class Real
    def get_images(params={})
      path = ""
      path = path + "/#{params[:resource]}"
      if params[:section]
        path = path + "/#{params[:section]}"
      elsif params[:subreddit]
        path = path + "/r/#{params[:subreddit]}"
      end
      path = path + "/#{params[:sort]}" if params[:sort]
      path = path + "/#{params[:page]}.json"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
