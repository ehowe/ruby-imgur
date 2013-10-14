class Imgur::Client::Comment < Imgur::Model
  identity :id

  attribute :image_id
  attribute :caption
  attribute :comment
  attribute :author
  attribute :author_id, type: :integer
  attribute :on_album,  type: :boolean
  attribute :album_cover
  attribute :ups,       type: :integer
  attribute :downs,     type: :integer
  attribute :points,    type: :float
  attribute :datetime,  type: :integer
  attribute :parent_id, type: :integer
  attribute :deleted,   type: :boolean
  attribute :children,  type: :array

  def reply(reply)
    image_type = on_album ? "album" : "image"
    data = connection.add_comment_reply({image_type: image_type, image_id: image_id, comment_id: id}, reply).body["data"]
    connection.comments.get(data["id"])
  end
end
