ENV['RACK_ENV'] = "test"

require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

Factory.define(:card) do |card|
  card.number '5454545454545454'
  card.year   Time.now.year
  card.month  Time.now.month
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
end
