class Imgur::Client::Account < Imgur::Model
  identity :id

  attribute :url
  attribute :bio
  attribute :reputation, type: :float
  attribute :created,    type: :integer

  def images
    path = "/account/me/images"
    data = connection.get_images(path: path).body["data"]
    connection.images.load(data)
  end

  def albums
    path = "/account/me/albums"
    data = connection.get_albums(path: path).body["data"]
    connection.albums.load(data)
  end
end
