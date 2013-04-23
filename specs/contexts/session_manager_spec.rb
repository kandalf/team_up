require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe SessionManager do
  def setup
    Ohm.flush
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

  it "should signup from the auth hash" do
    ctx = MiniTest::Mock.new
    ctx.expect :login, "1", [User, 'nickname', 'password']

    user = User.with(:email, @auth_hash["info"]["email"])
    user.must_be_nil

    user = SessionManager.new(@auth_hash, ctx).execute
    user.wont_be_nil
    
    user = User.with(:email, @auth_hash["info"]["email"])
    user.wont_be_nil
  end

  it "should get organizations from auth hash" do
    @auth_hash["extra"] = {
        "raw_info" => { "organizations_url" => "http://github.com/orgs" }
    }

    #Avoids actual http request and controls the input
    module RestClient 
      @@orgs_response = '[
          {
            "login": "fakeorg",
            "id": 6864,
            "url": "https://api.github.com/orgs/fakeorg",
            "repos_url": "https://api.github.com/orgs/fakeorg/repos",
            "events_url": "https://api.github.com/orgs/fakeorg/events",
            "members_url": "https://api.github.com/orgs/fakeorg/members{/member}",
            "public_members_url": "https://api.github.com/orgs/fakeorg/public_members{/member}",
            "avatar_url": "https://secure.gravatar.com/avatar/"
          },
          {
            "login": "otherorg",
            "id": 6865,
            "url": "https://api.github.com/orgs/otherorg",
            "repos_url": "https://api.github.com/orgs/otherorg/repos",
            "events_url": "https://api.github.com/orgs/otherorg/events",
            "members_url": "https://api.github.com/orgs/otherorg/members{/member}",
            "public_members_url": "https://api.github.com/orgs/otherorg/public_members{/member}",
            "avatar_url": "https://secure.gravatar.com/avatar/"
          }

      ]'
      
      def self.get(url)
        @@orgs_response
      end
    end

    user = User.create(
      :full_name => @auth_hash["info"]["name"],
      :github_user => @auth_hash["info"]["nickname"],
      :email => @auth_hash["info"]["email"],
      :gravatar_url => @auth_hash["info"]["image"]
    )

    ctx = MiniTest::Mock.new
    ctx.expect :login, user.id, [User, 'nickname', 'password']

    SessionManager.new(@auth_hash, ctx).execute

    user = User.fetch(@auth_hash["info"]["nickname"])
    user.wont_be_nil

    assert user.organizations.include? "fakeorg"
    assert user.organizations.include? "otherorg"
  end
end
