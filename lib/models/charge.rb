class Charge < ActiveRecord::Base

  belongs_to :card

  # charge = card.charges.create(:amount => 599)
  # charge.verification_value = '123'
  # charge.capture!
  def capture!(verification_value = nil)
    gateway.capture(amount, card.to_active_merchant(verification_value), :ip => card.ip_address)
  end

  private
    def gateway
      @gateway ||= ActiveMerchant::Billing::PaypalGateway.new(gateway_config.symbolize_keys)
    end

    def gateway_config
      YAML.load(File.read(gateway_config_file))[ENV['RACK_ENV']]
    end

    def gateway_config_file
      File.dirname(__FILE__) + '/../../config/paypal.yml'
    end
end
