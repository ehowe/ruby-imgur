class Imgur::Client::MessageNotifications < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::MessageNotification

  model_root "data"

  collection_root "data"

end
