class Imgur::Client::Replies < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Reply

  model_root "data"

  collection_root "data"

end
