class Imgur::Client::Images < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Image

  model_root "data"
  model_request :get_image

  collection_root "data"
  collection_request :get_images

  def all(options={})
    path = _generate_path_from_options options
    data = connection.get_images(path: path).body['data']
    connection.images.load(data)
  end

  def upload(options={})
    raise ArgumentError, ':image is missing: File name or URL requrired' unless options[:image]
    options[:image] = case options[:image]
                      when /^(http|ftp)/
                        options[:image]
                      when /\.(jp(e)?g|gif|bmp|png|tif(f)?)$/i
                        File.open(options[:image], 'rb')
                      else
                        raise ArgumentError, "Invalid image value"
                      end
    data = connection.upload_image(options).body["data"]
    connection.images.new(data)
  end

  private

  # used to return early if missing path options (cannot have
  # later path options without earlier path options)
  # @param [Object] options
  # @return [String]
  def _generate_path_from_options(options)
    path = ''

    path = path + "/#{options[:resource] || 'gallery'}"
    if options[:section]
      path = path + "/#{options[:section]}"
    elsif options[:subreddit]
      path = path + "/r/#{options[:subreddit]}"
    else
      # can't have sort without section
      return path
    end

    # can't have page without sort
    return path unless options[:sort]

    path + "/#{options[:sort]}/#{options[:page] || 0}.json"
  end

end
