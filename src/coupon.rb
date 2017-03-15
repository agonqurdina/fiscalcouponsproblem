class Coupon
  attr_accessor :id, :price

  def initialize(price, id)
    self.id = id
    self.price = price
  end

  def cost(free_amount)
    (free_amount - price).abs
  end
end