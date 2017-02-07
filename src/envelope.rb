class Envelope
  attr_accessor :envelope_type, :coupons

  def current_amount
    self.coupons.inject(:+)
  end

  def free_amount
    self.min_amount - self.current_amount
  end

  def min_amount
    self.envelope_type.min_amount
  end
end