class ToyBoatRaces
  def initialize(text, ignoring_spaces: false)
    times, distances = text.lines(chomp: true).map do |line|
      values = line.split(':')[1]
      if ignoring_spaces
        [values.gsub(' ', '').to_i]
      else
        values.split(' ').map(&:to_i)
      end
    end
    @races = times.zip(distances).map { Race[_1, _2] }
  end

  attr :races

  Race = Data.define(:time, :distance) do
    def times_to_equal_the_record
      # Holding down the button for x milliseconds causes the boat to go x*(t-x) millimeters.
      # So the times to equal the distance record are the solutions to x*(t-x) = d,
      # which are the roots of -x^2+tx-d = 0, which we can solve via the quadratic formula.
      a, b, c = -1, time, -distance
      discriminant = Math.sqrt(b*b - 4*a*c)
      [(-b + discriminant)/(2*a),
       (-b - discriminant)/(2*a)]
    end

    def times_to_beat_the_record
      low_time, high_time = times_to_equal_the_record
      (low_time + 1).floor .. (high_time - 1).ceil
    end
  end

  def product_of_ways_to_beat_the_records
    races.map { _1.times_to_beat_the_record.size }.reduce(:*)
  end
end

if defined? DATA
  text = DATA.read
  puts ToyBoatRaces.new(text).product_of_ways_to_beat_the_records
  puts ToyBoatRaces.new(text, ignoring_spaces: true).product_of_ways_to_beat_the_records
end

__END__
Time:        44     89     96     91
Distance:   277   1136   1890   1768
