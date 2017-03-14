class EnvelopeType
  attr_accessor :min_coupons, :min_amount, :price

  def initialize(min_coupons,min_amount,price)
    self.min_coupons = min_coupons
    self.min_amount = min_amount
    self.price = price
  end

  def score
    #price / (min_amount / min_coupons), where (min_amount / min_coupons) is average coupon price
    price.to_f / (min_amount.to_f / min_coupons.to_f)
  end
end
