require 'spec_helper'

describe "images" do
  let(:client) { create_client }

  it "should contain images" do
    images = client.images.all
    images.should_not be_empty
    images.first.should be_a_kind_of(Imgur::Client::Image)
  end

  it "should upload an image from filesystem" do
    image = File.expand_path("spec/support/ruby_logo.jpg")
    title = "ruby_logo_jpg"
    response = client.images.upload(image: image, title: title)
    response.should be_a_kind_of(Imgur::Client::Image)
    image = client.images.get(response.id)
    image.title.should == title

    response = response.delete
    response.should be_a_kind_of(Imgur::Client::BasicResponse)
  end

  it "should upload an image from the internet" do
    image = "http://www.ruby-lang.org/images/logo.gif"
    title = "ruby_logo_gif"
    response = client.images.upload(image: image, title: title)
    response.should be_a_kind_of(Imgur::Client::Image)
    image = client.images.get(response.id)
    image.title.should == title

    response = response.delete
    response.should be_a_kind_of(Imgur::Client::BasicResponse)
  end
end
