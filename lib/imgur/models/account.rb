class Imgur::Client::Account < Imgur::Model
  identity :id

  attribute :url
  attribute :bio
  attribute :reputation, type: :float
  attribute :created,    type: :integer

  def open_in_browser
    Launchy.open(link)
  end
end
