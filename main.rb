require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/solution.rb'
require './src/grasp.rb'

grasp = Grasp.new(0.01)
grasp.initialize_from_file('./storage/Testinstances/500-50000/Instance10.txt')
grasp.execute!

puts 'Unassigned coupons: '
puts grasp.best_solution.unassigned_coupons.length
puts grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.join(',')
puts 'Envelopes length: '
puts grasp.best_solution.envelopes.length
puts 'Envelopes: '
puts grasp.best_solution.envelopes.map { |e| e.envelope_type.price }.join(',')
puts grasp.best_solution.envelopes.map { |e| e.current_amount.to_f.round(2) }.join(',')
puts 'Total Price: '
puts grasp.best_solution.cost