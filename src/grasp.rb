class Grasp
  attr_accessor :envelope_types, :envelopes, :coupons

  def initialize_from_file(path)
    self.envelope_types = []
    self.coupons = []

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

        self.envelope_types << EnvelopeType.new(min_count, max_amount, price)
      end

      file.readline # skip duplicate Totali

      # Create Coupons
      coupons_count.times do
        price = file.readline.to_f
        self.coupons << Coupon.new(price) if price
      end
    end
  end


end