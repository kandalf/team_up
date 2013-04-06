class StandupCreator
  def initialize(args = {}, context = nil)
    @previous = args[:previous] || args["previous"]
    @next     = args[:next]     || args["next"]
    @blockers = args[:blockers] || args["blockers"]
    @context  = context
  end

  def execute
    attributes = {
      :previous => @previous,
      :next => @next,
      :blockers => @blockers,
      :date => Time.now
    }

    if (@context && @context.current_user)
      @context.current_user.standups.create(attributes)
    else
      Standup.create(attributes)
    end
  end
end
