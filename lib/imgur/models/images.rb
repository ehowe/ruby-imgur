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

  def upload(options={})
    raise ArgumentError, ":image is missing: File name or URL requrired" unless options[:image]
    options[:image] = case options[:image]
                      when /^(http|ftp)/
                        options[:image]
                      when /\.(jp(e)?g|gif|bmp|png|tif(f)?)$/i
                        options[:upload] = :image
                        File.open(options[:image], "rb")
                      else
                        raise ArgumentError, "Invalid image value"
                      end
    data = connection.upload_image(options)
  end
end
