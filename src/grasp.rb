class Grasp
  attr_accessor :envelope_types, :best_solution, :available_coupons, :random_percentage, :random_count

  def initialize
    self.envelope_types = []
    self.available_coupons = []
    self.random_percentage = 0.07
  end

  def initialize_from_file(path)
    initialize

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

  def initial_greedy_solution(candidate_solution = nil, current_envelope_type_index = 0)
    if candidate_solution.nil?
      candidate_solution = Solution.new
    end
    current_envelope = Envelope.new(envelope_types[current_envelope_type_index])
    available_coupons.length.times do |i|
      coupons = available_coupons.sort_by { |o| o.cost(current_envelope.free_amount) }.first(random_count)
      coupon = coupons[rand(coupons.length)]
      current_envelope.coupons << coupon
      available_coupons.delete coupon

      if current_envelope.valid?
        candidate_solution.envelopes << current_envelope
        current_envelope = Envelope.new(envelope_types[current_envelope_type_index])
      end
    end

    unless current_envelope.valid?
      self.available_coupons += current_envelope.coupons

      if current_envelope_type_index < envelope_types.length - 1
        initial_greedy_solution(candidate_solution, current_envelope_type_index + 1)
      end
    end
    candidate_solution
  end

  def tweak
    candidate_solution = Solution.new(best_solution.envelopes)
  end
end