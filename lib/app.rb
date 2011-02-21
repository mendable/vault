module Vault
  class App < Sinatra::Base

    def self.app
      self.new
    end

    configure do
      set :show_exceptions => false
    end

    before do
      content_type 'application/xml', :charset => 'utf-8'

      db = File.dirname(__FILE__) + '/../config/database.yml'
      db_params = YAML.load(File.read(db))[settings.environment.to_s]
      ActiveRecord::Base.establish_connection(db_params)
    end

    not_found do
      content_type 'application/xml', :charset => 'utf-8'
      builder do |xml|
        xml.instruct!
        xml.error do
          xml.message "Not Found"
          xml.backtrace ""
        end
      end
    end

    error do
      content_type 'application/xml', :charset => 'utf-8'
      builder do |xml|
        xml.instruct!
        xml.error do
          xml.message request.env['sinatra.error'].message
          xml.backtrace request.env['sinatra.error'].backtrace
        end
      end
    end

    # Card.build
    get '/cards/new.xml' do
    end

    # Create
    post '/cards.xml' do
    end

    # Read
    get '/cards/:id.xml' do
      Shop.find_by_id(params['id']).try(:to_xml) || not_found
    end

    # Update
    put '/cards/:id.xml' do      
    end

    # Destroy
    delete '/cards/:id.xml' do
    end

    post '/cards/:id/authorize.xml' do      
    end

    post '/cards/:id/authorize_and_capture.xml' do
    end

    post '/cards/:id/capture.xml' do
    end
  end
end
