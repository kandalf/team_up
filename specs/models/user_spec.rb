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

  it "should belong to an allowed organization to be allowed" do
    ENV['TEAM_UP_ORGS'] = 'threefunkymonkeys'

    user = User.new(:organizations => 'other')
    assert !user.allowed?

    user = User.new(:organizations => 'threefunkymonkeys')
    assert user.allowed?
  end
end
