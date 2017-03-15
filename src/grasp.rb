require "deep_clone"
class Grasp
  attr_accessor :envelope_types, :best_solution, :available_coupons, :random_percentage, :random_count, :max_no_improvement, :max_iterations

  def initialize(random_percentage = 0.07, max_iterations = 10, max_no_improvement = 50)
    self.envelope_types = []
    self.available_coupons = []
    self.max_no_improvement = max_no_improvement
    self.max_iterations = max_iterations
    self.random_percentage = random_percentage
  end

  def initialize_from_file(path)
    self.envelope_types = []
    self.available_coupons = []

    File.open(path) do
      # @type [File] file
    |file|

      # Read Metadata
      coupons_count = file.readline.split(':').last.to_i
      total_price = file.readline.split(':').last.to_i
      envelope_count = file.readline.split(':').last.to_i

      # Create Envelope Types
      file.readline.split('=').last.to_s.scan(/\(.*?\)/).each do |match|
        match[0] = match[match.length - 1] = ''

        min_count, max_amount, price = match.split(',')

        self.envelope_types << EnvelopeType.new(min_count.to_i, max_amount.to_i, price.to_f)
      end

      self.envelope_types.sort_by! { |o| o.price }.reverse!

      # file.readline # skip duplicate Totali

      # Create Coupons
      coupons_count.times do |i|
        price = file.readline.to_f
        self.available_coupons << Coupon.new(price, i+1) if price
      end
    end

    self.random_count = random_percentage * available_coupons.length
  end

  def execute!(mode = 0)
    sort_envelope_types(mode)
    index = 0
    all_coupons = self.available_coupons
    time = Time.new
    while index < max_iterations
      self.available_coupons = DeepClone.clone(all_coupons)
      solution = initial_greedy_solution
      test = solution.cost
      solution = spread_non_assigned_coupons(solution)
      solution = local_search(solution)
      if best_solution.nil? or solution.cost > best_solution.cost
        self.best_solution = solution
      end
      p 'cost: ' + solution.cost.to_s
      index += 1
    end
    execution_time = (Time.new - time)
    puts "\nFinished!"
    puts "\nExecution time: " + execution_time.to_s
  end

  private
  def sort_envelope_types(mode)
    #modes: 0 - sort by :price, 1 - higher average coupon price - better, 2 - lower average coupon price - better
    if mode == 0
      self.envelope_types = envelope_types.sort {|x,y| y.price <=> x.price}
    elsif mode == 1
      self.envelope_types = envelope_types.sort {|x,y| y.score <=> x.score}
    elsif mode == 2
      self.envelope_types = envelope_types.sort {|x,y| x.score <=> y.score}
    end
  end

  def initial_greedy_solution(candidate_solution = nil, envelope_type_index = 0)
    if candidate_solution.nil?
      candidate_solution = Solution.new(envelope_types)
    end

    # TODO: chose between modes (lines) by uncomenting
    # current_envelope = Envelope.new(envelope_types.last) # ma shum variacion
    current_envelope = Envelope.new(envelope_types[envelope_type_index]) # ma pak variacion

    available_coupons.length.times do |i|
      coupons = available_coupons.sort_by { |o| o.cost(current_envelope.free_amount) }[0...random_count]
      coupon = coupons[rand(coupons.length)]
      current_envelope.coupons << coupon
      available_coupons.delete coupon

      if current_envelope.valid?
        candidate_solution.envelopes << current_envelope
        current_envelope = Envelope.new(envelope_types[envelope_type_index])
      end
    end

    unless current_envelope.valid?
      self.available_coupons += current_envelope.coupons

      if envelope_type_index < envelope_types.length - 1
        initial_greedy_solution(candidate_solution, envelope_type_index + 1)
      end
    end
    candidate_solution.unassigned_coupons = DeepClone.clone(self.available_coupons)
    candidate_solution
  end

  def spread_non_assigned_coupons(solution)
    # available_coupons.each_with_index do |coupon, index|
    #   envelopes_count = solution.envelopes.length
    #   solution.envelopes[index.modulo(envelopes_count)].coupons << coupon
    #   available_coupons.delete coupon
    # end
    if available_coupons.length > 0
      new_envelope = Envelope.new(envelope_types.last)
      new_envelope.coupons = available_coupons.clone
      available_coupons.clear

      solution.envelopes << new_envelope
    else
      solution.envelopes << Envelope.new(envelope_types.last)
    end

    solution
  end

  def local_search(solution)
    no_improvement_count = 0
    while no_improvement_count < self.max_no_improvement
      candidate_solution = tweak(solution)
      if candidate_solution.cost > solution.cost
        solution = candidate_solution
        p 'IMPROVEMENT'
        no_improvement_count = 0
      else
        p "tweak cost: #{candidate_solution.cost}"
        no_improvement_count += 1
      end
    end
    solution
  end

  def tweak(solution)
    candidate_solution = DeepClone.clone(solution)
    length = candidate_solution.envelopes.length
    rand1 = rand(length)
    rand2 = rand(length)
    while rand1 == rand2
      rand2 = rand(length)
    end
    mutate(candidate_solution, rand1, rand2)
    candidate_solution
  end

  def mutate(candidate_solution, val1, val2)
    envelopes = candidate_solution.envelopes
    arr1 = envelopes[val1].coupons
    arr2 = envelopes[val2].coupons

    # coupon1 = envelopes[val1].coupons.sample
    # index1 = envelopes[val1].coupons.index(coupon1)
    # coupon2 = envelopes[val2].coupons.sample
    # index2 = envelopes[val2].coupons.index(coupon2)

    max_length = [arr1.length - 1, arr2.length - 1].max

    rand1 = rand(max_length)
    begin
      rand2 = rand(max_length)
    end while rand2 < rand1

    tmp = arr1[rand1..rand2]
    arr1[rand1..rand2] = arr2[rand1..rand2]
    arr2[rand1..rand2] = tmp

    p [rand1, rand2]
    arr1.delete_if { |i| i.nil? }
    arr2.delete_if { |i| i.nil? }


    # envelopes[val1].coupons[index1], envelopes[val2].coupons[index2] = envelopes[val2].coupons[index2], envelopes[val1].coupons[index1]
  end
end