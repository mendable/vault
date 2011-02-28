require 'spec_helper'

describe Charge do
  it { should have_db_column(:id).of_type(:integer) }
  it { should have_db_column(:card_id).of_type(:integer) }
  it { should have_db_column(:amount).of_type(:integer) }
  it { should have_db_column(:success).of_type(:boolean) }
  it { should have_db_column(:fraud_review).of_type(:boolean) }
  it { should have_db_column(:authorization).of_type(:string) }
  it { should have_db_column(:avs_result).of_type(:string) }
  it { should have_db_column(:cvv_result).of_type(:string) }
  it { should have_db_column(:message).of_type(:text) }
  it { should have_db_column(:params).of_type(:text) }
  it { should have_db_column(:test).of_type(:boolean) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should belong_to(:card) }

end
