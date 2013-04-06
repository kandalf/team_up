require 'cuba'
require 'cuba/render'
require 'rack/protection'
require 'securerandom'
require './lib/team_up'
require 'ohm'

Ohm.connect(:url => 'redis://127.0.01:6379/team_up_dev')

Cuba.settings[:sass] = {
  :style => :compact,
  :template_location => 'assets/stylesheets'
}

Cuba.settings[:render]= {:template_engine => :haml}

Cuba.use Rack::Session::Cookie, :secret => SecureRandom.hex(64)
Cuba.use Rack::Protection
Cuba.plugin Cuba::Render
Cuba.plugin Cuba::Sass

include Cuba::Render::Helper

Dir["./routes/**/*.rb"].each{ |f| require f }
Dir["./models/**/*.rb"].each{ |f| require f }

Cuba.define do
  on get do
    run TeamUp::Dashboard
  end

  on "standups" do
    run TeamUp::Standup
  end
end
