require "ohm"

class Standup < Ohm::Model
  attribute :previous
  attribute :next
  attribute :blockers
  attribute :date

  reference :user, :User
end
