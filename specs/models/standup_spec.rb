require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe Standup do
  it "should have previous and next" do
    standup = Standup.new
    assert !standup.valid?

    standup.previous = "Previous task"
    standup.next = "Next task"

    assert standup.valid?
  end
end
