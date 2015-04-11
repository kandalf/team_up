require 'cuba'
require 'cuba/render'
require 'cuba/flash'
require 'rack/protection'
require 'shield'
require 'omniauth-github'
require_relative 'lib/team_up'
require_relative 'helpers/environment'

ENV['RACK_ENV'] ||= :development

Cuba.settings[:sass] = {
  :style => :compact,
  :template_location => 'assets/stylesheets'
}

Cuba.settings[:render]= {:template_engine => :haml}

I18n.load_path += Dir['./locale/**/*.yml']
Encoding.default_internal, Encoding.default_external = ['utf-8'] * 2

TeamUp::Helpers.init_environment(ENV['RACK_ENV'])

Cuba.use Rack::Static,
          root: File.expand_path(File.dirname(__FILE__)) + "/public",
          urls: %w[/img /css /js]

Cuba.use Rack::Session::Cookie, :key => 'teamup.session', :secret => ENV["SESSION_SECRET"]
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
