require './src/coupon.rb'
require './src/envelope.rb'
require './src/envelope_type.rb'
require './src/solution.rb'
require './src/grasp.rb'
require 'readline'
require 'csv'

best_parameters = [1,1000,7,0]
instances = ['Instance1','Instance2','Instance3','Instance4','Instance5','Instance6','Instance7','Instance8','Instance9','Instance10']

instances.each do |instance|
  10.times do |i|
    CSV.open("./storage/ExperimentsNEW/Final/#{instance}/#{instance}_E#{i}.csv", "wb") do |csv|
      csv << ["Time", "Fitnes"]
    end
    grasp = Grasp.new(best_parameters[0], best_parameters[1], best_parameters[2], best_parameters[3])
    grasp.initialize_from_file(ARGV[0] || "./storage/Testinstances/New Set/#{instance}.txt")
    executions = grasp.execute!

    puts 'instance: '
    puts instance.inspect
    puts 'i: '
    puts i.inspect
    puts 'Total Price: '
    total_price = grasp.best_solution.cost
    puts total_price
    puts 'times: '
    puts executions.inspect
    CSV.open("./storage/ExperimentsNEW/Final/#{instance}/#{instance}_E#{i}.csv", "a+") do |csv|
      executions.each do |values|
        csv << [values[:time], values[:cost]]
      end
    end
  end
end

return
parameters = {
    max_iterations: [
        [1,10,10,0],
        [2,10,10,0],
        [3,10,10,0],
        [4,10,10,0]
    ],
    max_no_improvement: [
        [2,8,10,0],
        [2,10,10,0],
        [2,12,10,0],
        [2,14,10,0]
    ],
    random_percentage: [
        [2,10,5,0],
        [2,10,7,0],
        [2,10,10,0]
    ],
    mode: [
        [2,10,10,0],   #params
        [2,10,10,1],
        [2,10,10,2]
    ]
}

  # default_max_iteration = parameters[:max_iterations][3]    #12
  # default_max_no_improvement = parameters[:max_no_improvement][3]   #14
  # default_random = parameters[:random_percentage][2]    #10
  # default_mode = parameters[:mode][0]   #0

  parameters.each do |key, values|
    CSV.open("./storage/ExperimentsNEW/Parameters/#{key}.csv", "wb") do |csv|
      csv << ["Max Iterations", "Max No Improvement", "Random Percentage", "Mode", "Instance", "Best Fitnes", "Average Fitnes", "Worst Fitnes", "Best Time", "Average Time", "Worst Time"]
    end
    values.each do |params|
      instances.each do |instance|
        costs = []
        times = []
        10.times do |i|
          grasp = Grasp.new(params[0], params[1], params[2], params[3])
          grasp.initialize_from_file(ARGV[0] || "./storage/Testinstances/New Set/#{instance}")
          execution_time = grasp.execute!

          puts 'Total Price: '
          total_price = grasp.best_solution.cost
          costs << total_price
          puts total_price
          # puts 'Envelopes: '
          # envelopes = grasp.best_solution.envelopes.select { |e| e.valid? }.map { |e| e.envelope_type.price }.join(',')
          # puts envelopes
          # puts grasp.best_solution.envelopes.select { |e| e.valid? }.map { |e| e.current_amount.to_f.round(2) }.join(',')
          puts 'time: '
          times << execution_time
          puts execution_time
          # puts 'Unassigned coupons total: '
          # unassigned_coupons_length = grasp.best_solution.unassigned_coupons.length
          # puts unassigned_coupons_length
          # puts 'Unassigned coupons price: '
          # unassigned_coupons_price = grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.inject(:+).to_f.round(2)
          # puts unassigned_coupons_price
          # puts 'Total Price: ' + grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.inject(:+).to_f.round(2).to_s
          # puts 'Coupons: ' + grasp.best_solution.unassigned_coupons.map {|c| c.price.to_f.round(2)}.join(',')
          # puts 'Envelopes length: '
          # puts grasp.best_solution.envelopes.select { |e| e.valid? }.length

          puts "Key: #{key.inspect}"
          puts "Params: #{params.inspect}"
          puts "Instance: #{instance.inspect}"
          puts "i: #{i.inspect}"
          sleep 1
        end
        best_fitnes = costs.max.to_f.round(2)
        worst_fitnes = costs.min.to_f.round(2)
        avg_fitnes = (costs.sum.to_f / costs.length.to_f).round(2)
        best_time = times.min.to_f.round(2)
        worst_time = times.max.to_f.round(2)
        avg_time = (times.sum.to_f / times.length.to_f).round(2)
        CSV.open("./storage/ExperimentsNEW/Parameters/#{key}.csv", "a+") do |csv|
          csv << [params[0], params[1], params[2], params[3], instance, best_fitnes, avg_fitnes, worst_fitnes, best_time, avg_time, worst_time]
        end
      end
    end
    sleep(1)
    end
