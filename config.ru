require File.dirname(__FILE__) + '/config/boot.rb'

run Rack::URLMap.new({
            "/"    => Vault::App.new
})