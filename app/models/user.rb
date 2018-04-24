require 'csv'

class User < ActiveRecord::Base
  extend ActionView::Helpers::NumberHelper

  has_many :auctions
  validates :name, presence: true

  alias_method :number, :id

  def self.is_name?(search)
    search.length == 0 || search.length != search.to_i.to_s.length
  end

  def self.search(search)
    if search
      if self.is_name?(search)
        where('lower(name) LIKE lower(?)', "%#{search}%")
      else
        where(id: search)
      end
    else
      all
    end
  end

  def self.to_summary_csv
    CSV.generate(headers: true) do |csv|
      csv << ['number', 'name', 'phone number', 'number of auctions', 'total purchased', 'total due', 'paid?']
      running_total = 0
      User.includes(:auctions).find_each do |user|
        running_total += user.total_purchased
        csv << [user.id,
                user.name,
                user.phone_number,
                user.auctions.count,
                number_to_currency(user.total_purchased),
                number_to_currency(user.total_due),
                user.paid?]
      end
      csv << ["total", number_to_currency(running_total)]
    end
  end

  def self.to_itemized_csv
    CSV.generate(headers: true) do |csv|
      csv << ['Participant (number)', 'price', 'item name', 'paid?']


      running_total = 0
      User.includes(:auctions).find_each do |user|
        running_total += user.total_purchased
        user.auctions.each_with_index do |auction, i|
          csv << [i == 0 ? "#{user.name} (#{user.id})" : '',
                  number_to_currency(auction.value),
                  auction.name.present? ? auction.name :  "UNNAMED AUCTION",
                  auction.paid?]
        end
      end
    csv << ["total", number_to_currency(running_total)]
    end
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << ['item name', 'price', 'paid?']
      auctions.each do |auction|
        csv << [auction.name, self.class.number_to_currency(auction.value), auction.paid?]
      end
      csv << ['']
      csv << ["total purchased", self.class.number_to_currency(total_purchased)]
      csv << ["total due", self.class.number_to_currency(total_due)]
    end
  end

  def csv_filename
    "#{name}(#{number})-#{Date.today}.csv"
  end

  def phone_number
    return '' unless self.attributes['phone_number'].present?
    pn = self.attributes['phone_number'].gsub("-","").split('')
    pn.count == 10 ? (pn[0..2] + ['-'] + pn[3..5] + ['-'] + pn[6..9]).join : @phone_number
  end

  def paid?
    self.unpaid_auctions.empty?
  end

  def total_due
    # Bypass scope to make use of association cache
    self.unpaid_auctions.inject(0){|mem, act| mem += act.value}
  end

  def total_purchased
    self.auctions.inject(0){|mem, act| mem += act.value}
  end

  def unpaid_auctions
    self.auctions.select{|auction| !auction.paid}
  end
end
