class Imgur::Client::Account < Imgur::Model
  identity :id

  attribute :url
  attribute :bio
  attribute :reputation, type: :float
  attribute :created,    type: :integer

  def images
    data = []
    image_array = []
    page = 0
    until data.count > 0 && data.count != 50
      path = "/account/me/images/#{page}"
      data = connection.get_images(path: path).body["data"]
      data.each { |i| image_array << i }
      page += 1
    end
    connection.images.load(image_array)
  end

  def albums
    path = "/account/me/albums"
    data = connection.get_albums(path: path).body["data"]
    connection.albums.load(data)
  end

  def notifications
    data = connection.get_notifications.body('data')
    connection.notifications.load(data)
  end
end
