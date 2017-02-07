require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/grasp.rb'

grasp = Grasp.new
grasp.initialize_from_file('./storage/Testinstances/500-50000/Instance10.txt')
grasp.execute!

p grasp.available_coupons.first
p grasp.envelopes.length
p grasp.envelopes.map { |e| e.envelope_type.price }

p grasp.envelopes.map { |e| e.coupons.count }

p grasp.envelopes[8].coupons.map {|c| c.price}

