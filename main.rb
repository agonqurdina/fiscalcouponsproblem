require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/solution.rb'
require './src/grasp.rb'


grasp = Grasp.new
grasp.initialize_from_file('./storage/Testinstances/500-50000/Instance10.txt')
p grasp.available_coupons.length
grasp.execute!

p 'Unassigned coupons: '
p grasp.best_solution.unassigned_coupons.length
p 'Envelopes length: '
p grasp.best_solution.envelopes.length
p 'Envelopes: '
p grasp.best_solution.envelopes.map { |e| e.envelope_type.price }
p 'Total Price: '
p grasp.best_solution.cost