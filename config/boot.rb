ENV["RACK_ENV"] ||= "development"

require 'bundler'
Bundler.setup

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

# Setup database connection when starting server.
db = File.dirname(__FILE__) + '/../config/database.yml'
db_params = YAML.load(File.read(db))[ENV['RACK_ENV']]
ActiveRecord::Base.establish_connection(db_params)


Dir["./lib/**/*.rb"].each { |f| require f }

