require 'spec_helper'

describe "clients" do
  let (:client) { create_client }
  it "should have credits" do
    client.credits.should_not be_nil
    pending if client.credits == "0/1000"
  end
end
