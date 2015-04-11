module TeamUp
  module Helpers
    def self.init_environment(env)
      self.set_env(env)

      db_params = {
        'host' => ENV["DATABASE_HOST"],
        'port' => ENV["DATABASE_PORT"],
        'user' => ENV["DATABASE_USER"],
        'password' => ENV["DATABASE_PASS"],
        'db_name' => ENV["DATABASE_NAME"]
      }

      Sequel.connect self.connection_path(db_params)
    end

    def self.set_env(env)
      filename = env.to_s + ".env.sh"

      if File.exists? filename
        env_vars = File.read(filename)
        env_vars.each_line do |var|
          name, value = var.split("=")
          if name && value
            ENV[name.strip] = value.strip
          end
        end
      end
    end

    def self.connection_path(settings)
      "postgres://#{settings['user']}:#{settings['password']}@#{settings['host']}:#{settings['port']}/#{settings['db_name']}"
    end
  end
end
