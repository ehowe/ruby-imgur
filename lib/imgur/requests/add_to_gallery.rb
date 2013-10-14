class Imgur::Client
  class Real
    def add_to_gallery(id, options={})
      path = "/gallery/#{id}"

      request(
        :method => :post,
        :path   => path,
        :params => options
      )
    end
  end

end
