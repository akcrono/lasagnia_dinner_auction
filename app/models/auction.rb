class Auction < ActiveRecord::Base
  belongs_to :user

  scope :unpaid, -> { where(paid: false) }

  attr_accessor :quantity, :user_ids

  def self.dinner_cost
    20
    # TODO persist somewhere
  end
end
