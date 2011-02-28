require 'rspec/core/rake_task'
require File.expand_path(File.dirname(__FILE__) + "/config/boot")

task :environment do
  # Any tasks required to setup environment.
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
    ActiveRecord::Base.connection.execute("DROP DATABASE #{DATABASE_CONFIG['database']}") rescue nil
    ActiveRecord::Base.connection.execute("CREATE DATABASE #{DATABASE_CONFIG['database']}")
    ActiveRecord::Base.establish_connection(DATABASE_CONFIG) # borking otherwise
    Rake::Task["db:migrate"].invoke
  end
end

desc "Run specs"
task(:spec => :environment) do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = './spec/**/*_spec.rb'
  end
end
