class Coupon
  attr_accessor :price

  def initialize(price)
    self.price = price
  end

  def cost(free_amount)
    (free_amount - price).abs
  end
end