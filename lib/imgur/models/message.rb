class Imgur::Client::Message < Imgur::Model
  identity :id

  attribute :from
  attribute :account_id, type: :int
  attribute :recipient_account_id, type: :int
  attribute :subject
  attribute :body
  attribute :timestamp, type: :string
  attribute :parent_id, type: :int

end
