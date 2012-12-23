ENV["IMGUR_MOCK"] ||= 'false'

Bundler.require(:test)
Bundler.require(:darwin) if RUBY_PLATFORM.match(/darwin/)
require File.expand_path("../../lib/imgur", __FILE__)
Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each{|f| require(f)}

Cistern.formatter = Cistern::Formatter::AwesomePrint

if ENV["IMGUR_MOCK"] == 'true'
  Cistern.timeout = 0
  Imgur::Client.mock!
end

RSpec.configure do |config|
  config.before(:all) do
    Imgur::Client.reset! if Imgur::Client.mocking?
  end
end
