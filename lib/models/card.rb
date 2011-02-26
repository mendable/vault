class Card < ActiveRecord::Base

  # Number Validations
  validates :number, :presence => true
  validates :issue_number, :numericality => true, :allow_nil => true

  # Date Validations
  validates :month, :year, :presence => true, :numericality => true
  validates :start_month, :inclusion => {:in => [nil, 1,2,3,4,5,6,7,8,9,10,11,12] }
  validates :start_year, :numericality => true, :allow_nil => true

  validates_each :month, :year do |record, attribute, value|
    if record.year && record.month then
      if Date.parse("#{record.year}-#{record.month}-01") < Time.now.to_date.beginning_of_month then
        record.errors[attribute] << "Cannot be in the past"
      end
    end
  end

  validates_each :start_month, :start_year do |record, attribute, value|
    if record.start_month && record.start_year then
      if Date.parse("#{record.start_year}-#{record.start_month}-01") > Time.now.to_date.beginning_of_month then
        record.errors[attribute] << "Cannot be in the future"
      end
    end
  end

end