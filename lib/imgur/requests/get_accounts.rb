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

  class Mock
    def get_accounts(params={})
      accounts = self.data[:accounts].values.first
      response(body: {"data" => accounts})
    end
  end
end
