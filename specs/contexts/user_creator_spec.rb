require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe SessionManager do
  def setup
    @attributes = {
      :full_name => "Ed Vedder",
      :github_user => "pearljam",
      :email => "eddie@example.com",
      :gravatar_url => "http://somepic.com",
      :password => "testpass",
    }

    @auth_hash = {
      "uid" => "1111",
      "info" => {
        "name" => "Jeff Ament",
        "nickname" => "jeff",
        "email" => "jeff@example.com",
        "image" => "http://example.com/pic.jpg",
      },
      "extra" => {}
    }
  end

  it "should signup from the auth_hash" do
    ctx = MiniTest::Mock.new
    ctx.expect :login, "1", [User, 'nickname', 'password']

    user = User.with(:email, @auth_hash["info"]["email"])
    user.must_be_nil

    user = SessionManager.new(@auth_hash, ctx).execute
    user.wont_be_nil
    
    user = User.with(:email, @auth_hash["info"]["email"])
    user.wont_be_nil
  end
end
