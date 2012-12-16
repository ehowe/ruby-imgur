class Imgur::Client::Album < Imgur::Model
  identity :id

  attribute :title
  attribute :link
  attribute :datetime,   type: :integer
  attribute :description
  attribute :privacy
  attribute :cover
  attribute :order,      type: :integer
  attribute :layout

  def images
    url  = "/album/#{id}/images"
    data = connection.get_images(path: url).body["data"]
    connection.images.load(data)
  end
end
