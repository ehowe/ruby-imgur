class Imgur::Client::Image < Imgur::Model
  identity :id

  attribute :title
  attribute :link
  attribute :datetime,               type: :integer
  attribute :mime_type, alias: :type
  attribute :animated,               type: :boolean
  attribute :width,                  type: :integer
  attribute :height,                 type: :integer
  attribute :size,                   type: :integer
  attribute :views,                  type: :integer
  attribute :bandwidth,              type: :integer
  attribute :deletehash

  def open_in_browser
    Launchy.open("http://imgur.com/#{id}")
  end

  def delete
    data = connection.delete_image(deletehash).body
    connection.basic_responses.new(data)
  end

  def add_to_gallery(options = {})
    data = connection.add_to_gallery(id, options).body['data']
    new(data)
  end
end
