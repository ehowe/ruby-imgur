module ClientHelper
  def create_client(attributes={})
    config = YAML.load_file(File.expand_path("~/.imgurrc")) || YAML.load_file("config/config.yml")
    merged_attributes = attributes.merge(config: config)
    merged_attributes.merge!(logger: Logger.new(STDOUT)) if ENV['VERBOSE']

    Imgur::Client.new(merged_attributes)
  end
end

RSpec.configure do |config|
  config.include(ClientHelper)
end
