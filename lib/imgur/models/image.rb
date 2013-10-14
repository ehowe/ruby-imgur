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
  attribute :account_url
  attribute :bandwidth,              type: :integer
  attribute :ups,                    type: :integer
  attribute :downs,                  type: :integer
  attribute :score,                  type: :integer
  attribute :is_album,               type: :boolean
  attribute :deletehash

  def open_in_browser
    Launchy.open(link)
  end

  def delete
    data = connection.delete_image(deletehash).body
    connection.basic_responses.new(data)
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
end
