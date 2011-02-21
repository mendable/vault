require 'spec_helper'

describe Vault::App do
  
  def app
    @app ||= Vault::App.app
  end

  describe "GET '/'" do
    it "should be successful" do
      get '/'
      last_response.should be_ok
    end
  end
end
