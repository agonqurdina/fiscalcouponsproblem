class Envelope
  attr_accessor :envelope_type, :coupons

  def initialize(type)
    self.envelope_type = type
    self.coupons = []
  end

  def current_amount
    self.coupons.map {|i| i.price}.inject(:+) || 0
  end

  def free_amount
     free_amount = self.min_amount - self.current_amount
    if free_amount < 0
      free_amount = 0
    end
    free_amount
  end

  def min_amount
    envelope_type.min_amount
  end

  def min_coupons
    envelope_type.min_coupons
  end

  def valid_amount?
    current_amount >= min_amount
  end

  def filled?
    coupons.length >= min_coupons
  end

  def valid?
    filled? and valid_amount?
  end
end