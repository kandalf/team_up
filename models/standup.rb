require "ohm"

class Standup < Ohm::Model
  attribute :previous
  attribute :next
  attribute :blockers
  attribute :date

  reference :user, :User

  def validate
    assert_present :previous
    assert_present :next
  end
end
