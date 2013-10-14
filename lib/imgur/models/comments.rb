class Imgur::Client::Comments < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::Comment

  model_root "data"
  model_request :get_comment

  collection_root "data"
  collection_request :get_comment

  def get(id)
    connection.comments.new(connection.get_comment(id).body["data"])
  end
end
