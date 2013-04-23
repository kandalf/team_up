require "ohm"

class User < Ohm::Model
  include Shield::Model

  attribute :full_name
  attribute :github_user
  attribute :email
  attribute :crypted_password
  attribute :gravatar_url
  attribute :organizations
  collection :standups, :Standup

  unique :github_user
  unique :email

  index :github_user
  index :email

  def initialize(attrs)
    super(attrs)
    self.organizations ||= ""
  end

  def self.fetch(github_user)
    with(:github_user, github_user)
  end


  def allowed?
    allowed_orgs = ENV['TEAM_UP_ORGS'].split(' ') || []
    self.organizations.any? do |org|
      allowed_orgs.include? org
    end
  end
end
