class Imgur::Client::GalleryImages < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::GalleryImage

  model_root "data"
  model_request :get_image

  collection_root "data"
  collection_request :get_images
end
