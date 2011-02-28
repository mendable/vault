class CreateSchema < ActiveRecord::Migration

  create_table :cards do |t|
    t.string :first_name
    t.string :last_name
    t.string :number
    t.integer :month
    t.integer :year
    t.integer :start_month
    t.integer :start_year
    t.integer :issue_number
    t.string :ip_address
    t.timestamps
  end

  create_table :charges do |t|
    # Charge linked to card. Can be null if old card that has subsequently been removed.
    t.integer :card_id

    # Amount in lowest currency denominator, eg, pennies, cents, etc.
    t.integer :amount

    # ActiveMerchant::Billing::Response
    t.boolean :success
    t.boolean :fraud_review
    t.string :authorization
    t.string :avs_result
    t.string :cvv_result
    t.text :message
    t.text :params
    t.boolean :test

    # Created_at is time API was called to create charge
    # Updated_at is time response recived from Gateway
    t.timestamps
  end

end
