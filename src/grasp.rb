require "deep_clone"
class Grasp
  attr_accessor :envelope_types, :best_solution, :available_coupons, :random_percentage, :random_count, :max_iterations

  def initialize(random_percentage = 0.07, max_iterations = 50)
    self.envelope_types = []
    self.available_coupons = []
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
      coupons_count = file.readline.split('=').last.to_i
      total_price = file.readline.split('=').last.to_i
      envelope_count = file.readline.split('=').last.to_i

      # Create Envelope Types
      file.readline.split('=').last.to_s.scan(/\(.*?\)/).each do |match|
        match[0] = match[match.length - 1] = ''

        min_count, max_amount, price = match.split(',')

        self.envelope_types << EnvelopeType.new(min_count.to_i, max_amount.to_i, price.to_f)
      end

      self.envelope_types.sort_by! { |o| o.price }.reverse!

      file.readline # skip duplicate Totali

      # Create Coupons
      coupons_count.times do
        price = file.readline.to_f
        self.available_coupons << Coupon.new(price) if price
      end
    end
    self.random_count = random_percentage * available_coupons.length
  end

  def execute!
    self.best_solution = initial_greedy_solution
    tweak
  end

  private
  def initial_greedy_solution(candidate_solution = nil, envelope_type_index = 0)
    if candidate_solution.nil?
      candidate_solution = Solution.new
    end
    current_envelope = Envelope.new(envelope_types[envelope_type_index])
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

    available_coupons.each_with_index do |coupon, index|
      envelopes_count = candidate_solution.envelopes.length
      candidate_solution.envelopes[envelopes_count.modulo(index)] << coupon
    end
  end

  def tweak
    no_improvement_count = 0
    while no_improvement_count < self.max_iterations
      candidate_solution = DeepClone.clone(best_solution)
      length = candidate_solution.envelopes.length
      rand1 = rand(length)
      rand2 = rand(length)
      while rand1 == rand2
        rand2 = rand(length)
      end
      mutate(candidate_solution, rand1, rand2)
      if candidate_solution.cost > best_solution.cost
        self.best_solution = candidate_solution
        p 'IMPROVEMENT'
        no_improvement_count = 0
      else
        no_improvement_count += 1
      end
    end
  end

  def mutate(candidate_solution, val1, val2)
    envelopes = candidate_solution.envelopes
    envelopes[val1].coupons[0], envelopes[val2].coupons[0] = envelopes[val2].coupons[0], envelopes[val1].coupons[0]
    # candidate_solution.update_envelopes
  end
end