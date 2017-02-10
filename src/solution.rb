class Solution
  attr_accessor :envelopes, :unassigned_coupons

  def initialize(solution = nil)
    if solution.nil?
      self.envelopes = []
      self.unassigned_coupons = []
    else
      self.envelopes = solution.envelopes
      self.unassigned_coupons = solution.unassigned_coupons
    end
  end

  def cost
    cost = 0
    if envelopes.length > 0
      update_envelopes
      cost = envelopes.map {|e| e.envelope_type.price}.inject(:+)
    end
    cost
  end

  private
  def update_envelopes
    invalid_envelopes = []
    envelopes.each do |envelope|
      unless envelope.valid?
        unassigned_coupons += envelope.coupons
        invalid_envelopes << envelope
      end
    end
    invalid_envelopes.each do |envelope|
      envelopes.delete envelope
    end
  end

end