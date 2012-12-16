class Imgur::Client::Albums < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Album

  model_root "data"
  model_request :get_album

  collection_root "data"
  collection_request :get_albums

  def get(id)
    connection.albums.new(connection.get_album(id).body["data"])
  end
end
