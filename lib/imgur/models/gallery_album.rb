class Imgur::Client::GalleryAlbum < Imgur::Client::Album

  attribute :account_url
  attribute :vote
  attribute :ups,       type: :integer
  attribute :downs,     type: :integer
  attribute :score,     type: :integer
  attribute :is_album,  type: :boolean

  def add_to_gallery
    throw new Error, 'Album already in gallery'
  end
end
