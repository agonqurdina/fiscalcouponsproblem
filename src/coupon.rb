class Coupon
  attr_accessor :price

  def initialize(price)
    self.price = price
  end

  def cost(envelope)
    (envelope.free_amount - price).to_i.abs
  end
end