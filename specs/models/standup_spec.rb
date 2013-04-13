require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe Standup do
  it "should have previous and next" do
    standup = Standup.new
    standup.wont_be :valid?

    standup.previous = "Previous task"
    standup.next = "Next task"

    standup.must_be :valid?
  end
end
