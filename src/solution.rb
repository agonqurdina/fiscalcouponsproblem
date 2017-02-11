class Solution
  attr_accessor :envelopes, :unassigned_coupons

  def initialize
    self.envelopes = []
    self.unassigned_coupons = []
  end

  def cost
    cost = 0
    if envelopes.length > 0
      update_envelopes
      cost = envelopes.map {|e| e.envelope_type.price}.inject(:+)
    end
    cost
  end

  def update_envelopes
    invalid_envelopes = []
    envelopes.each do |envelope|
      unless envelope.valid?
        self.unassigned_coupons += envelope.coupons
        invalid_envelopes << envelope
      end
    end
    invalid_envelopes.each do |envelope|
      self.envelopes.delete envelope
    end
  end

end