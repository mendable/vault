require 'spec_helper'

describe Vault::App do

  class TestCard < ActiveResource::Base
    self.site = 'http://localhost:9292' #not used
    self.element_name = 'cards'
  end

  def app
    @app ||= Vault::App.app
  end


  specify "GET '/cards/new.xml'" do
    get '/cards/new.xml'

    t = TestCard.new.send(:load_attributes_from_response, last_response)
    t.attributes.should == Card.new.attributes

    t.id.should == nil
    last_response.status.should == 200
  end


  specify "POST '/cards.xml' - valid card" do
    card = Card.new(:number => '123')
    post '/cards.xml', card.to_xml

    t = TestCard.new.send(:load_attributes_from_response, last_response)
    t.should_not be_nil

    t.attributes.should == Card.last.attributes
    t.id.should == Card.last.id

    last_response.status.should == 201 #:created in rails
    last_response.location.should == "/cards/#{Card.last.id}.xml"
  end


  specify "POST '/cards.xml' - invalid card" do
    post '/cards.xml', Card.new.to_xml

    r = ActiveResource::Errors.from_xml(last_response.body)
    r.should_not be_empty
    r['errors'].should_not be_empty
    r['errors']['error'].should == "Number can't be blank"

    last_response.status.should == 422
    last_response.location.should be_nil
  end


  context "GET /cards/:id.xml" do
    specify "when not found" do
      get '/cards/does_not_exist.xml'
      last_response.status.should == 404
    end

    specify "when found" do
      db = Card.create!(:number => '12345')
      get "/cards/#{db.id}.xml"
      last_response.status.should == 200
      t = TestCard.new.send(:load_attributes_from_response, last_response)
      t.attributes.should == db.reload.attributes
    end
  end
  
  
  context "PUT /cards/:id.xml" do
    specify "when valid" do
      card = Card.create!(:number => '2222').reload
      card.number = '555'
      put "/cards/#{card.id}.xml", card.to_xml

      card.reload.number.should == '555'
      last_response.status.should == 204
    end

    specify "when invalid" do
      card = Card.create!(:number => '2222').reload
      card.number = ''
      put "/cards/#{card.id}.xml", card.to_xml
      
      card.reload.number.should == '2222' # not changed
      last_response.status.should == 422
    end
  end


  context "DELETE /cards/:id.xml" do
    specify "should work" do
      card = Card.create!(:number => '2222').reload

      delete "/cards/#{card.id}.xml"
      
      Card.find_by_id(card.id).should be_nil

      last_response.status.should == 200
      last_response.body.should == ''
    end
  end
end
