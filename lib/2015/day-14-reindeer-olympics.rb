require_relative '../util'

class ReindeerOlympics
  def initialize(reindeer_specs)
    @reindeer = reindeer_specs.split("\n").map(&Reindeer.method(:new)).index_by(&:name)
  end

  def [](name)
    @reindeer[name]
  end

  class Reindeer
    attr_reader :name, :speed, :fly, :rest

    def initialize(spec)
      raise unless spec =~ /^(\w+) can fly (\d+) km\/s for (\d+) seconds?, but then must rest for (\d+) seconds?\.$/
      @name = $1
      @speed, @fly, @rest = [$2, $3, $4].map &:to_i
    end

    def distance(time)
      cycles = time / cycle_time
      remainder_time = time % cycle_time
      cycles * distance_per_cycle + @speed * [remainder_time, @fly].min
    end

    private

    def cycle_time
      @fly + @rest
    end

    def distance_per_cycle
      @speed * @fly
    end
  end

  def winner_distance(time)
    @reindeer.values.map { |r| r.distance(time) }.max
  end

  def points(time)
    points = @reindeer.keys.map { |name| [name, 0] }.to_h
    for t in 1..time
      distances = @reindeer.values.map { |r| [r, r.distance(t)] }
      winning_distance = distances.map { |r, d| d }.max
      distances.each do |r, d|
        points[r.name] += 1 if d == winning_distance
      end
    end
    points
  end

  def winner_points(time)
    points(time).map { |name, points| points }.max
  end
end

if defined? DATA
  race = ReindeerOlympics.new(DATA.read.chomp)
  puts race.winner_distance(2503)
  puts race.winner_points(2503)
end

__END__
Vixen can fly 19 km/s for 7 seconds, but then must rest for 124 seconds.
Rudolph can fly 3 km/s for 15 seconds, but then must rest for 28 seconds.
Donner can fly 19 km/s for 9 seconds, but then must rest for 164 seconds.
Blitzen can fly 19 km/s for 9 seconds, but then must rest for 158 seconds.
Comet can fly 13 km/s for 7 seconds, but then must rest for 82 seconds.
Cupid can fly 25 km/s for 6 seconds, but then must rest for 145 seconds.
Dasher can fly 14 km/s for 3 seconds, but then must rest for 38 seconds.
Dancer can fly 3 km/s for 16 seconds, but then must rest for 37 seconds.
Prancer can fly 25 km/s for 6 seconds, but then must rest for 143 seconds.
