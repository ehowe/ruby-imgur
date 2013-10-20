class Imgur::Client::MessageNotification < Imgur::Model
  identity :id

  attribute :account_id, type: :integer
  attribute :viewed,  type: :boolean
  attribute :content

  def mark_as_read
    connection.mark_notification_read id
    self
  end

  def message
    connection.messages.new(content)
  end
end
