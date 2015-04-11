require 'cuba'
require 'cuba/render'
require 'cuba/flash'
require 'rack/protection'
require 'shield'
require 'omniauth-github'
require 'sequel'
require_relative 'lib/team_up'
require_relative 'helpers/environment_helper'

ENV['RACK_ENV'] ||= "development"

Cuba.settings[:render]= {:template_engine => :haml}

Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2

TeamUp::Helpers.init_environment(ENV['RACK_ENV'])

Cuba.use Rack::Static,
          root: File.expand_path(File.dirname(__FILE__)) + "/public",
          urls: %w[/images /stylesheets /javascripts]

Cuba.use Rack::Session::Cookie, :key => 'teamup.session', :secret => ENV["SESSION_SECRET"]
Cuba.use Rack::Protection
Cuba.use Rack::MethodOverride

OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}

Cuba.use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], :scope => "user,repo"
end

Cuba.plugin Shield::Helpers
Cuba.plugin Cuba::Render
Cuba.plugin TeamUp::Context

include Cuba::Render::Helper

Dir["./routes/**/*.rb"].each{ |f| require f }
Dir["./models/**/*.rb"].each{ |f| require f }
Dir["./contexts/**/*.rb"].each{ |f| require f }

Cuba.define do
  settings[:render][:layout] = "layouts/application"

  on root do
    if current_user
      res.redirect '/dashboard'
    else
      res.write view("home/home")
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
