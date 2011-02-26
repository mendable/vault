require 'rspec/core/rake_task'
require File.expand_path(File.dirname(__FILE__) + "/config/boot")

task :environment do
  db = File.dirname(__FILE__) + '/config/database.yml'
  databases = YAML.load(File.read(db))
  ActiveRecord::Base.establish_connection(databases[settings.environment.to_s])
end


namespace :db do
  desc "Migrate the database"
  task(:migrate => :environment) do
    ActiveRecord::Base.logger = nil
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate")
  end
end

desc "Run specs"
task(:spec => :environment) do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end
