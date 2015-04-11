class User < Sequel::Model
  include Shield::Model

  one_to_many :standups

  def initialize(attrs = {})
    super(attrs)
    self.organizations ||= ""
  end

  def self.fetch(github_user)
    find(:github_user => github_user)
  end

  def allowed?
    allowed_orgs = ENV['TEAM_UP_ORGS'].split(' ') || []
    self.organizations.split(" ").any? do |org|
      allowed_orgs.include? org
    end
  end

  def can_standup?
   !today_standup
  end

  def today_standup
    Standup.find(:user_id => self.id, :date => Date.today.to_s)
  end
end
