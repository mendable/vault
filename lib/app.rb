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
      Card.new.to_xml
    end

    # Create
    post '/cards.xml' do
      card_params = Hash.from_xml(request.body.read)['card']

      c = Card.new(card_params)
      if c.save then
        response.status = 201
        response['Location'] = "/cards/#{c.id}.xml"
        c.to_xml
      else
        response.status = 422
        c.errors.to_xml
      end
    end

    # Read
    get '/cards/:id.xml' do
      Card.find_by_id(params[:id]).try(:to_xml) || not_found
    end

    # Update
    put '/cards/:id.xml' do
      card_params = Hash.from_xml(request.body.read)['card']

      card = Card.find_by_id(params[:id])
      return not_found unless card

      if card.update_attributes(card_params) then
        response.status = 204
        return ""
      else
        response.status = 422
        card.errors.to_xml
      end
    end

    # Destroy
    delete '/cards/:id.xml' do
      card = Card.find_by_id(params[:id])
      return not_found unless card
      card.destroy
      ""
    end
  end
end
