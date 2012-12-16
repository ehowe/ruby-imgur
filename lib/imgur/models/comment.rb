class Imgur::Client::Comment < Imgur::Model
  identity :id

  attribute :image_id
  attribute :caption
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
end
