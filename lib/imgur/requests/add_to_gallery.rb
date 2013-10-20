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

  class Mock
    def add_to_gallery(id)
      image = self.data[:images][id['id']]
      response(:body => {'data' => image})
    end
  end

end
