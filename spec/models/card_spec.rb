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

  it { should validate_presence_of(:month) }
  it { should validate_presence_of(:year) }

  it { should validate_numericality_of(:issue_number) }
  it { should allow_value(nil).for(:issue_number) }

  it { should validate_numericality_of(:month) }
  it { should validate_numericality_of(:year) }
  it { should validate_numericality_of(:start_year) }
  it { should allow_value(nil).for(:start_month) }
  it { should allow_value(nil).for(:start_year) }

  context "Expiry Date Validation" do
    before(:each) do
      @card = Card.new
    end

    specify "when todays month and year" do
      @card.year = Time.now.year
      @card.month = Time.now.month
      @card.valid?
      @card.errors[:year].should be_empty
      @card.errors[:month].should be_empty
    end

    specify "when in the future by 1 month" do
      @card.year = Time.now.year
      @card.month = Time.now.month + 1 #FIXME: Test will fail in December months
      @card.valid?
      @card.errors[:year].should be_empty
      @card.errors[:month].should be_empty
    end

    specify "when in the future by a year" do
      @card.year = Time.now.year + 1
      @card.month = Time.now.month
      @card.valid?
      @card.errors[:year].should be_empty
      @card.errors[:month].should be_empty
    end

    specify "when a month in the past" do
      @card.year = Time.now.year
      @card.month = Time.now.month - 1 #FIXME: Test will fail in January months
      @card.valid?
      @card.errors[:year].should_not be_empty
      @card.errors[:month].should_not be_empty
    end

    specify "when todays month and year in the past" do
      @card.year = Time.now.year - 1
      @card.month = Time.now.month
      @card.valid?
      @card.errors[:year].should_not be_empty
      @card.errors[:month].should_not be_empty
    end
  end

  context "Start Date Validation" do
    before(:each) do
      @card = Card.new
    end

    specify "when todays month and year" do
      @card.start_year = Time.now.year
      @card.start_month = Time.now.month
      @card.valid?
      @card.errors[:start_year].should be_empty
      @card.errors[:start_month].should be_empty
    end

    specify "when in the future by 1 month" do
      @card.start_year = Time.now.year
      @card.start_month = Time.now.month + 1 #FIXME: Test will fail in December months
      @card.valid?
      @card.errors[:start_year].should_not be_empty
      @card.errors[:start_month].should_not be_empty
    end

    specify "when in the future by a year" do
      @card.start_year = Time.now.year + 1
      @card.start_month = Time.now.month
      @card.valid?
      @card.errors[:start_year].should_not be_empty
      @card.errors[:start_month].should_not be_empty
    end

    specify "when a month in the past" do
      @card.start_year = Time.now.year
      @card.start_month = Time.now.month - 1 #FIXME: Test will fail in January months
      @card.valid?
      @card.errors[:start_year].should be_empty
      @card.errors[:start_month].should be_empty
    end

    specify "when todays month and year in the past" do
      @card.start_year = Time.now.year - 1
      @card.start_month = Time.now.month
      @card.valid?
      @card.errors[:start_year].should be_empty
      @card.errors[:start_month].should be_empty
    end
  end

  context "number and real_number" do
    specify "should validate presence of real_number" do
      @card = Card.new(:number => nil)
      @card.valid?
      @card.errors[:number].should include "Number can't be blank"

      @card.number = '234'
      @card.valid?
      @card.errors[:number].should_not include "Number can't be blank"
    end

    specify "when regular length number is entered, number method never returns it again in full" do
      @card = Card.new(:number => '1234123412345678')
      @card.number.should == '************5678'
      @card.real_number.should == '1234123412345678'
    end

    specify "when short invalid number is entered, number masking function doesn't break (eg, nil operations during masking)" do
      @card = Card.new(:number => '12')
      @card.number.should == '************12'
      @card.real_number.should == '12'
    end
  end

  context "to_xml" do
    specify "should never include the full credit card number, only the masked" do
      @card = Card.new(:number => '1111222233334444')
      @card.to_xml.should_not match /1111222233334444/i
      @card.to_xml.should match /\*\*\*\*\*\*\*\*\*\*\*\*4444/i
    end
  end

end