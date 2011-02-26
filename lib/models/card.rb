class Card < ActiveRecord::Base
  validates :number, :presence => true
end