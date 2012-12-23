class Imgur::Client
  class Real
    def get_albums(params={})
      path = params[:path]
      request(
        method: :get,
        path:   path,
      )
    end
  end

  class Mock
    def get_albums(params={})
      albums = self.data[:albums].values
      albums = if params[:path] =~ /^\/account/
                 {"data" => albums.select { |a| !a["account_id"].nil? } }
               else
                 {"data" => albums}
               end

      response(body: albums)
    end
  end
end
