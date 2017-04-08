class Auction < ActiveRecord::Base
  belongs_to :user

  attr_accessor :quantity, :user_numbers
end
