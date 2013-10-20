class Imgur::Client::GalleryImage < Imgur::Client::Image

  attribute :account_url
  attribute :vote
  attribute :ups,       type: :integer
  attribute :downs,     type: :integer
  attribute :score,     type: :integer
  attribute :is_album,  type: :boolean


  def open_in_browser
    Launchy.open("http://imgur.com/gallery/#{id}")
  end

  def comments
    type = is_album ? "album" : "image"
    data = connection.get_comments(type: type, id: id).body["data"]
    connection.comments.load(data)
  end

  def add_comment(comment)
    type = is_album ? "album" : "image"
    data = connection.add_comment({type: type, id: id}, comment).body["data"]
    connection.comments.get(data["id"])
  end

  def add_to_gallery
    throw new Error, 'Image already in gallery'
  end
end
