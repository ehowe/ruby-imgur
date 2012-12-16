class Imgur::Client
  class Real
    def get_images(params={})
      path = ""
      path = path + "/#{params[:resource] || "gallery"}"
      if params[:section]
        path = path + "/#{params[:section]}"
      elsif params[:subreddit]
        path = path + "/r/#{params[:subreddit]}"
      end
      path = path + "/#{params[:sort]}" if params[:sort]
      path = path + "/#{params[:page] || 0}.json"

      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
