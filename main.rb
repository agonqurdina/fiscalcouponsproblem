require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/solution.rb'
require './src/grasp.rb'
require 'readline'

# arr1 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
# arr2 = ['a', 'b', 'c', 'd']
#
# max_length = [arr1.length - 1, arr2.length - 1].max
#
# rand1 = rand(max_length)
# begin
#   rand2 = rand(max_length)
# end while rand2 < rand1
#
# p tmp = arr1[rand1..rand2]
# p arr1[rand1..rand2] = arr2[rand1..rand2]
# p arr2[rand1..rand2] = tmp
#
# p [rand1, rand2]
# arr1.delete_if { |i| i.nil? }
# arr2.delete_if { |i| i.nil? }
#
# p arr1
# p arr2

grasp = Grasp.new(0.01)
grasp.initialize_from_file(ARGV[0] || './storage/Testinstances/500-50000/Instance10.txt')
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