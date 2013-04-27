class StandupCreator
  class NoOwnerError < RuntimeError;end
  class NotAllowedError < RuntimeError;end

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
      :date => Date.today.to_s
    }

    current_user = @context.current_user if @context

    if (current_user)
      if current_user.can_standup?
        attributes[:user_id] = current_user.id
        Standup.create(attributes)
      else
        raise NotAllowedError.new("User can't create standup")
      end
    else
      raise NoOwnerError.new('No owner specified for standup')
    end
  end
end
