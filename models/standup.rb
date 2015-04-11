class Standup < Sequel::Model
  many_to_one :user

  def editable?
    !!(self.date == Date.today.to_s)
  end

  def self.for(date)
    where(:date => date.to_s)
  end

  def self.last_ones
    where("date != '#{Date.today.to_s}'").order_by(Sequel.desc(:date))
  end
end
