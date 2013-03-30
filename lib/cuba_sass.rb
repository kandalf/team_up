require 'sass'
require 'sass/plugin/rack'

class Cuba
  module Sass
    def self.setup(app)
      sass_options = ::Sass::Plugin.options

      options = {
        :style => :compressed,
        :syntax => :sass,
        :always_check => (ENV["RACK_ENV"] != "production"),
        :always_update => (ENV["RACK_ENV"] != "production"),
        :template_location => "app/assets/stylesheets",
        :css_location => "public/stylesheets"
      }

      app.settings[:sass] ||= {}
      app.settings[:sass] = options.merge(app.settings[:sass])

      ::Sass::Plugin.options = sass_options.merge(app.settings[:sass])
      Cuba.use ::Sass::Plugin::Rack
    end
  end
end
