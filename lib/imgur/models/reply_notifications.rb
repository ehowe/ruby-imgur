class Imgur::Client::ReplyNotifications < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::ReplyNotification

  model_root "data"

  collection_root "data"

end
