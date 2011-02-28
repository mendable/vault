ENV["RACK_ENV"] ||= "development"

require 'bundler'
Bundler.setup

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

# Setup database connection when starting server.
all_database_config = File.dirname(__FILE__) + '/../config/database.yml'
DATABASE_CONFIG = YAML.load(File.read(all_database_config))[ENV['RACK_ENV']]
ActiveRecord::Base.establish_connection(DATABASE_CONFIG)

# Setup ActiveMerchant environment
if ENV['RACK_ENV'] != 'production' then
  ActiveMerchant::Billing::Base.mode = :test
end

Dir["./lib/**/*.rb"].each { |f| require f }

