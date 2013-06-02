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

  def editable?
    !!(self.date == Date.today.to_s)
  end

  def self.for(date)
    find(:date => date.to_s)
  end

  def self.last_ones
    all.except(:date => Date.today.to_s).sort_by(:date, :order => "ALPHA DESC")
  end
end
