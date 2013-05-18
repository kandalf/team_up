require 'cuba'
require 'cuba/render'
require 'rack/protection'
require 'securerandom'
require 'ohm'
require 'shield'
require 'omniauth-github'
require './lib/team_up'

Ohm.connect(:url => Settings::REDIS_URL)

Cuba.settings[:sass] = {
  :style => :compact,
  :template_location => 'assets/stylesheets'
}

Cuba.settings[:render]= {:template_engine => :haml}

Cuba.use Rack::Session::Cookie, :key => 'teamup.session', :secret => '570e9854e1c8cd4ec5238ac66a2f574abc3e4da6809f1fc26248f825a09c693b'
Cuba.use Rack::Protection

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Cuba.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], :scope => "user,repo"
end

Cuba.plugin Shield::Helpers
Cuba.plugin Cuba::Render
Cuba.plugin Cuba::Sass
Cuba.plugin TeamUp::Context

include Cuba::Render::Helper

Dir["./routes/**/*.rb"].each{ |f| require f }
Dir["./models/**/*.rb"].each{ |f| require f }
Dir["./contexts/**/*.rb"].each{ |f| require f }

Cuba.define do
  on root do
    if current_user
      res.redirect '/dashboard'
    else
      res.write render("./views/layouts/application.haml") {
        render("views/home/home.haml")
      }
    end
  end

  on authenticated(User) do
    on "logout" do
      logout(User)
      res.redirect "/"
    end
    on "standups" do
      run TeamUp::Standup
    end

    on "dashboard" do
      run TeamUp::Dashboard
    end
  end

  on "auth" do
    run TeamUp::Session
  end
end
