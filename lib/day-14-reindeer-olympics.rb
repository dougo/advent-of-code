=begin

--- Day 14: Reindeer Olympics ---

This year is the Reindeer Olympics! Reindeer can fly at high speeds, but must rest occasionally to recover their
energy. Santa would like to know which of his reindeer is fastest, and so he has them race.

Reindeer can only either be flying (always at their top speed) or resting (not moving at all), and always spend
whole seconds in either state.

For example, suppose you have the following Reindeer:

 - Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
 - Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.

After one second, Comet has gone 14 km, while Dancer has gone 16 km. After ten seconds, Comet has gone 140 km,
while Dancer has gone 160 km. On the eleventh second, Comet begins resting (staying at 140 km), and Dancer
continues on for a total distance of 176 km. On the 12th second, both reindeer are resting. They continue to rest
until the 138th second, when Comet flies for another ten seconds. On the 174th second, Dancer flies for another 11
seconds.

In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km (poor
Dancer has only gotten 1056 km by that point). So, in this situation, Comet would win (if the race ended at 1000
seconds).

Given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, what distance has the
winning reindeer traveled?

--- Part Two ---

Seeing how reindeer move in bursts, Santa decides he's not pleased with the old scoring system.

Instead, at the end of each second, he awards one point to the reindeer currently in the lead. (If there are
multiple reindeer tied for the lead, they each get one point.) He keeps the traditional 2503 second time limit, of
course, as doing otherwise would be entirely ridiculous.

Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point. He stays
in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into the lead and
gets his first point. Of course, since Dancer had been in the lead for the 139 seconds before that, he has
accumulated 139 points by the 140th second.

After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312. So,
with the new scoring system, Dancer would win (if the race ended at 1000 seconds).

Again given the descriptions of each reindeer (in your puzzle input), after exactly 2503 seconds, how many points
does the winning reindeer have?

=end

class ReindeerOlympics
  def initialize(reindeer_specs)
    reindeer = reindeer_specs.split("\n").map(&Reindeer.method(:new))
    @reindeer = reindeer.map(&:name).zip(reindeer).to_h # aka reindeer.index_by &:name in Rails...
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
