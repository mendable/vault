require 'rspec/core/rake_task'
require File.expand_path(File.dirname(__FILE__) + "/config/boot")

db = File.dirname(__FILE__) + '/config/database.yml'
databases = YAML.load(File.read(db))
database_config = databases[settings.environment.to_s]

task :environment do
  ActiveRecord::Base.establish_connection(database_config)
end


namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end

  desc "reset database"
  task(:reset => :environment) do
    ActiveRecord::Base.connection.execute("DROP DATABASE #{database_config['database']}") rescue nil
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{database_config['database']}")
    ActiveRecord::Base.establish_connection(database_config) # borking otherwise
    Rake::Task["db:migrate"].invoke
  end
end

desc "Run specs"
task(:spec => :environment) do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end
