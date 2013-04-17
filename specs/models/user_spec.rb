require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe User do
  it "should be a Shield model" do
    User.must_include Shield::Model
  end

  it "should respond to fetch" do
    User.must_respond_to :fetch
  end

  it "should respond to crypted_password" do
    user = User.new
    user.must_respond_to :crypted_password
  end
end
