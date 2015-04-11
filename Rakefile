require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList["specs/**/*_spec.rb"]
  t.verbose = true

  namespace :db do
    desc "Run DB migrations on db/migrate directory"
    task :migrate do
      require 'sequel'
      require_relative 'helpers/environment_helper'
      require_relative 'lib/team_up'

      Sequel.extension :migration

      env = ENV['RACK_ENV'] || :development

      db_params = {
        'host' => ENV["DATABASE_HOST"],
        'port' => ENV["DATABASE_PORT"],
        'user' => ENV["DATABASE_USER"],
        'password' => ENV["DATABASE_PASS"],
        'db_name' => ENV["DATABASE_NAME"]
      }

      db = TeamUp::Helpers.init_environment(env)

      puts 'Running migrations...'

      Sequel::Migrator.run(db, "db/migrate")

      puts 'Done!'
    end

    namespace :schema do
      desc "Dump the DB schema to db/schema.rb"
      task :dump do
        require 'sequel'
        require_relative 'helpers/environment_helper'
        require_relative 'lib/team_up'

        env      ||= ENV['RACK_ENV'] || :development

        db = TeamUp::Helpers.init_environment(env)

        db.extension :schema_dumper

        puts "Dumping schema to db/schema.rb..."

        File.open("db/schema.rb", "w") do |f|
          f.puts db.dump_schema_migration
        end

        puts "Done!"
      end

      desc "Load the DB schema defined in db/schema.rb"
      task :load do
        require 'sequel'
        require_relative 'helpers/environment_helper'
        require_relative 'lib/team_up'

        Sequel.extension :migration

        puts "Loading schema..."
        env      ||= ENV['RACK_ENV'] || :test

        db = TeamUp::Helpers.init_environment(env)

        migration = eval(File.read('./db/schema.rb'))

        puts "Dropping old tables..."
        db.drop_table *db.tables, cascade: true

        puts "Applying new schema..."
        migration.apply(db, :up)

        puts "Done!"
      end
    end

    namespace :test do
      desc "Prepares test DB by copying current dev schema"
      task :prepare do
        require 'sequel'
        require_relative 'lib/team_up'

        env_val = ENV['RACK_ENV']

        ENV['RACK_ENV'] = 'development'
        Rake::Task["db:schema:dump"].invoke

        ENV['RACK_ENV'] = 'test'
        Rake::Task["db:schema:load"].invoke
      end
    end
  end
end
