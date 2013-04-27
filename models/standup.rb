require "ohm"

class Standup < Ohm::Model
  attribute :previous
  attribute :next
  attribute :blockers
  attribute :date

  reference :user, :User

  index :user_id
  index :date

  def validate
    assert_present :previous
    assert_present :next
  end
end
