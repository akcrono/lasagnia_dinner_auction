class User < ActiveRecord::Base
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

  def phone_number
    return '' if self.attributes['phone_number'].empty?
    pn = self.attributes['phone_number'].gsub("-","").split('')
    pn.count == 10 ? (pn[0..2] + ['-'] + pn[3..5] + ['-'] + pn[6..9]).join : @phone_number
  end

  def paid?
    self.auctions.select{|auction| !auction.paid}.empty?
  end

  def total_due
    self.auctions.select{|auction| !auction.paid}.inject(0){|mem, act| mem += act.value}
  end
end
