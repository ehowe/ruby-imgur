class Imgur::Client::BasicResponses < Cistern::Collection
  include Imgur::PagedCollection
  include Imgur::Collection

  model Imgur::Client::BasicResponse

  model_root "data"
  model_request :get_basic_response

  collection_root "data"
  collection_request :get_basic_responses

end
