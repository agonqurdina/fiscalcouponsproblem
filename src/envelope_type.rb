class EnvelopeType
  attr_accessor :min_coupons, :min_amount, :price

  def initialize(min_coupons,min_amount,price)
    self.min_coupons = min_coupons
    self.min_amount = min_amount
    self.price = price
  end
end
