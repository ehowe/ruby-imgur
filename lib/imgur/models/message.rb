class Imgur::Client::Message < Imgur::Model
  identity :id

  attribute :from
  attribute :account_id, type: :int
  attribute :recipient_account_id, type: :int
  attribute :subject
  attribute :body
  attribute :timestamp
  attribute :parent_id, type: :int

  def mark_as_read
    connection.mark_notification_read id
    self
  end

  def comment
    connection.comments.new(content)
  end
end
