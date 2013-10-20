class Imgur::Client::Messages < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Message

  model_root 'data'

  collection_root 'data'

end
