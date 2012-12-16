class Imgur::Client::Images < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Image

  model_root "data"
  model_request :get_image

  collection_root "data"
  collection_request :get_images
end
