require File.expand_path(File.dirname(__FILE__)) + '/../test_helper'

describe StandupCreator do
  def setup
    Standup.all.each { |s| s.delete }
  end

  it "should create with an allowed owner" do
    ctx = MiniTest::Mock.new
    user = User.create
    user.instance_eval <<-RUBY
      def can_standup?; true; end
    RUBY

    params = {:previous => 'Prev', :next => 'Next', :blockers => nil }

    ctx.expect(:current_user, user)

    standup = StandupCreator.new(params, ctx).execute
    standup.previous.must_equal params[:previous]
    standup.next.must_equal params[:next]
    standup.blockers.must_equal params[:blockers]
    standup.user.must_equal user
  end

  it "should not create with no owner" do
    ctx = MiniTest::Mock.new
    params = {:previous => 'Prev', :next => 'Next', :blockers => nil }

    ctx.expect(:current_user, nil)

    lambda {
      StandupCreator.new(params, ctx).execute
    }.must_raise(StandupCreator::NoOwnerError)
  end
  
  it "should not create if user is not allowed" do
    ctx = MiniTest::Mock.new
    user = MiniTest::Mock.new
    params = {:previous => 'Prev', :next => 'Next', :blockers => nil }

    user.expect(:can_standup?, false)
    ctx.expect(:current_user, user)

    lambda {
      StandupCreator.new(params, ctx).execute
    }.must_raise(StandupCreator::NotAllowedError)
  end
end
