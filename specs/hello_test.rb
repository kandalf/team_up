# cat hello_world_test.rb
require "cuba/test"
require "./camilo"

scope do
  test "Homepage" do
    get "/"

    follow_redirect!

    assert_equal "Hello", last_response.body
  end
end
