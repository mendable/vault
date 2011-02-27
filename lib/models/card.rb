class Card < ActiveRecord::Base

  # Number Validations
  validates :issue_number, :numericality => true, :allow_nil => true

  # Date Validations
  validates :month, :year, :presence => true, :numericality => true
  validates :start_month, :inclusion => {:in => [nil, 1,2,3,4,5,6,7,8,9,10,11,12] }
  validates :start_year, :numericality => true, :allow_nil => true

  # Validate presence of credit card number. Not a regular validation because we
  # need to read the real value from the real_number field, but attach errors to
  # the masked number field so the client API can pick them up correctly.
  validates_each :number do |record, attribute, value|
    record.errors[attribute] << "Number can't be blank" if record.real_number.blank?
  end

  # Expiry Date validations. It is permissable for card expiry dates to be this
  # month or in future, but may never be in the past.
  validates_each :month, :year do |record, attribute, value|
    if record.year && record.month then
      if Date.parse("#{record.year}-#{record.month}-01") < Time.now.to_date.beginning_of_month then
        record.errors[attribute] << "Cannot be in the past"
      end
    end
  end

  # Start Date validations. It is permissable for card start dates (if given) to
  # be this month or in the past, but cannot be in the future.
  validates_each :start_month, :start_year do |record, attribute, value|
    if record.start_month && record.start_year then
      if Date.parse("#{record.start_year}-#{record.start_month}-01") > Time.now.to_date.beginning_of_month then
        record.errors[attribute] << "Cannot be in the future"
      end
    end
  end

  # Override to_xml, it directly reads the attributes and by-passes our masking 
  # methods. Remove the direct read of the attribute, but add the same-named
  # method to the XML to keep the XML API consistent.
  def to_xml(options = {}, &block)
    super(options.merge(:except => [:number], :methods => [:number]), &block)
  end

  # Number takes the real credit card number and masks on top of it, so that
  # only the last 4 digits are returned, the rest of the digits padded with *
  def number
    t = (read_attribute(:number) || "")
     ('*' * 12) + (t[t.size-4..t.size] || '')
  end

  # When acccepting the credit card number, be permissable of any weird user 
  # input - only read in 0-9 numbers.
  def number=(num)
    write_attribute(:number, num ? num.scan(/\d+/).join : nil)
  end

  # This method provides access to the real credit card number in decrypted
  # form. This should never be exposed back to the application in full, ever.
  def real_number
    read_attribute(:number)
  end

end