require 'spec_helper'

describe "accounts" do
  let(:client) { create_client }

  it "should have images" do
    account = client.accounts.all.first
    images = account.images
    images.should_not be_empty
    images.first.should be_a_kind_of(Imgur::Client::Image)
  end

  it "should have albums" do
    account = client.accounts.all.first
    albums  = account.albums
    albums.should_not be_empty
    albums.first.should be_a_kind_of(Imgur::Client::Album)

    album = albums.select { |a| a.privacy == "public" }.last
    album_images = album.images
    album_images.should_not be_empty
    album_images.first.should be_a_kind_of(Imgur::Client::Image)
  end
end
