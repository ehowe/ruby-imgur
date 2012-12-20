class Imgur::Client::BasicResponse < Imgur::Model
  attribute :data
  attribute :success, type: :boolean
  attribute :status,  type: :integer
end
