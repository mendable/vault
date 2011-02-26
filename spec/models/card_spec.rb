require 'spec_helper'

describe Card do
  it { should have_db_column(:id).of_type(:integer) }
  it { should have_db_column(:number).of_type(:string) }
  it { should have_db_column(:month).of_type(:integer) }
  it { should have_db_column(:year).of_type(:integer) }
  it { should have_db_column(:start_month).of_type(:integer) }
  it { should have_db_column(:start_year).of_type(:integer) }
  it { should have_db_column(:issue_number).of_type(:integer) }
  it { should have_db_column(:created_at).of_type(:datetime) }
  it { should have_db_column(:updated_at).of_type(:datetime) }

  it { should validate_presence_of(:number) }

end