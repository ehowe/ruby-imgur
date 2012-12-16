Bundler.require(:test)
Bundler.require(:darwin) if RUBY_PLATFORM.match(/darwin/)
require File.expand_path("../../lib/imgur", __FILE__)
Dir[File.expand_path("../{shared,support}/*.rb", __FILE__)].each{|f| require(f)}

Cistern.formatter = Cistern::Formatter::AwesomePrint

RSpec.configure do |config|
  config.before(:all) do
    Imgur::Client.reset! if Imgur::Client.mocking?
  end
end
