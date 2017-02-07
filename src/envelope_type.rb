class EnvelopeType
  attr_accessor :min_coupons, :min_value, :price

  def initialize(min_coupons,min_value,price)
    self.min_coupons = min_coupons
    self.min_value = min_value
    self.price = price
  end
end
