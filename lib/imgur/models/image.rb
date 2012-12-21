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
end
