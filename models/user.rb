require "ohm"

class User < Ohm::Model
  include Shield::Model

  attribute :full_name
  attribute :github_user
  attribute :email
  attribute :crypted_password
  attribute :gravatar_url

  unique :github_user
  unique :email

  index :github_user
  index :email

  collection :standups, :Standup

  def self.fetch(github_user)
    with(:github_user, github_user)
  end
end
