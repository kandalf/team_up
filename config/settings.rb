ENV['RACK_ENV'] ||= "development"

case ENV['RACK_ENV']
when "development"
  TEAM_UP_DB = 0
when "test"
  TEAM_UP_DB = 1
when "production"
  TEAM_UP_DB = 2
else
  raise "Invalid Environment"
end

class Settings
  REDIS_URL = "redis://127.0.01:6379/#{::TEAM_UP_DB}"
end
