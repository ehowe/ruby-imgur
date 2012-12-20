class Imgur::Client
  class Real
    def get_accounts(params={})
      path = params[:path]
      request(
        :method => :get,
        :path   => path,
      )
    end
  end
end
