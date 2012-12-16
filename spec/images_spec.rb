require 'spec_helper'

describe "images" do
  let(:client) { create_client }

  it "should contain images" do
    images = client.images.all
    images.should_not be_empty
    images.first.should be_a_kind_of(Imgur::Client::Image)
  end
end
