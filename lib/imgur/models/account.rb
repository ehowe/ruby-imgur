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

  # @TODO NOT FULLY IMPLEMENTED
  # returns message notifications, which in turn contain messages.  The data structure for a notification
  # is VERY different from a message, but notifications have two types: reply and message, so it is difficult
  # to model out in a simple way.
  def messages
    data = connection.get_notifications.body["data"]["messages"]
    connection.replies.load(data)
  end

end
