require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/solution.rb'
require './src/grasp.rb'
require 'readline'
require 'csv'

a = [3,5,8,10]
b = [8,10,12,14]
c = [1,5]
d = [0,1,2]
total = []
a.each do |a1|
  b.each do |b1|
    c.each do |c1|
      d.each do |d1|
        total.push [a1,b1,c1,d1]
      end
    end
  end
end

12.times do |i|
  instance = 'Instance' + (i+9).to_s

  CSV.open("./storage/Experiments/#{instance}.csv", "wb") do |csv|
    csv << ["max_iterations", "max_no_improvements", "random_percentage", "mode", "total_price", "envelopes", "time", "unassigned_coupons_total", "unassigned_coupons_price"]
  end

  CSV.open("./storage/Experiments/#{instance}.csv", "a+") do |csv|
    total.each do |row|
      grasp = Grasp.new(row[0], row[1], row[2], row[3])
      grasp.initialize_from_file(ARGV[0] || "./storage/Testinstances/New Set/#{instance}.txt")
      execution_time = grasp.execute!

      puts 'Row: '
      puts row.inspect
      puts 'Total Price: '
      total_price = grasp.best_solution.cost
      puts total_price
      puts 'Envelopes: '
      envelopes = grasp.best_solution.envelopes.select { |e| e.valid? }.map { |e| e.envelope_type.price }.join(',')
      puts envelopes
      # puts grasp.best_solution.envelopes.select { |e| e.valid? }.map { |e| e.current_amount.to_f.round(2) }.join(',')
      puts 'time: '
      puts execution_time
      puts 'Unassigned coupons total: '
      unassigned_coupons_length = grasp.best_solution.unassigned_coupons.length
      puts unassigned_coupons_length
      puts 'Unassigned coupons price: '
      unassigned_coupons_price = grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.inject(:+).to_f.round(2)
      puts unassigned_coupons_price
      # puts 'Total Price: ' + grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.inject(:+).to_f.round(2).to_s
      # puts 'Coupons: ' + grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.join(',')
      # puts 'Envelopes length: '
      # puts grasp.best_solution.envelopes.select { |e| e.valid? }.length

      csv << [row[0], row[1], row[2], row[3], total_price, envelopes, execution_time, unassigned_coupons_length, unassigned_coupons_price]

      sleep(3)
    end
  end
end
