class Imgur::Client::Images < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Image

  model_root "data"
  model_request :get_image

  collection_root "data"
  collection_request :get_images

  def all(options={})
    path = ""
    path = path + "/#{options[:resource] || "gallery"}"
    if options[:section]
      path = path + "/#{options[:section]}"
    elsif options[:subreddit]
      path = path + "/r/#{options[:subreddit]}"
    end
    path = path + "/#{options[:sort]}" if options[:sort]
    path = path + "/#{options[:page] || 0}.json"

    data = connection.get_images(path: path).body["data"]
    connection.images.load(data)
  end
end
