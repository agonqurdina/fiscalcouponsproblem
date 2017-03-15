class Solution
  attr_accessor :envelopes, :unassigned_coupons, :envelope_types

  def initialize(envelope_types)
    self.envelopes = []
    self.unassigned_coupons = []
    self.envelope_types = envelope_types
  end

  def cost
    cost = 0
    if envelopes.length > 0
      update_envelopes
      cost = envelopes.select { |e| e.valid? }.map { |e| e.envelope_type.price }.inject(:+)
      if unassigned_coupons.nil?
        self.unassigned_coupons = []
      end
      envelopes.select { |e| !e.valid? }.each do |envelope|
        unless envelope.coupons.nil?
          coupon_ids = unassigned_coupons.map {|uc| uc.id}
          self.unassigned_coupons += envelope.coupons.select {|unused_coupon| !coupon_ids.include?(unused_coupon.id) }
        end
      end
    end
    cost
  end

  def update_envelopes
    invalid_envelopes = []
    envelopes.each do |envelope|

      envelope_type_index = envelope_types.index(envelope.envelope_type)

      # downgrade till valid or no more downgrade available
      while !envelope.valid? and (envelope_type_index += 1) < envelope_types.length - 1
          envelope.envelope_type = envelope_types[envelope_type_index]
      end

      # upgrade while valid or no more upgrades available
      while envelope.valid? and (envelope_type_index -= 1) > 0
        envelope.envelope_type = envelope_types[envelope_type_index]
      end

      # possibly fix last upgrade
      if not envelope.valid? and envelope_type_index < envelope_types.length - 2
        envelope.envelope_type = envelope_types[envelope_type_index + 1]
      end

    end
    # invalid_envelopes.each do |envelope|
    #   self.envelopes.delete envelope
    # end
  end
end