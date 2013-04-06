require "ohm"

class User < Ohm::Model
  attribute :full_name
  attribute :github_user

  collection :standups, :Standup
end
