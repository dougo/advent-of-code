=begin

--- Day 13: Knights of the Dinner Table ---

In years past, the holiday feast with your family hasn't gone so well. Not everyone gets along! This year, you
resolve, will be different. You're going to find the optimal seating arrangement and avoid all those awkward
conversations.

You start by writing up a list of everyone invited and the amount their happiness would increase or decrease if
they were to find themselves sitting next to each other person. You have a circular table that will be just big
enough to fit everyone comfortably, and so each person will have exactly two neighbors.

For example, suppose you have only four attendees planned, and you calculate their potential happiness as follows:

 - Alice would gain 54 happiness units by sitting next to Bob.
 - Alice would lose 79 happiness units by sitting next to Carol.
 - Alice would lose 2 happiness units by sitting next to David.
 - Bob would gain 83 happiness units by sitting next to Alice.
 - Bob would lose 7 happiness units by sitting next to Carol.
 - Bob would lose 63 happiness units by sitting next to David.
 - Carol would lose 62 happiness units by sitting next to Alice.
 - Carol would gain 60 happiness units by sitting next to Bob.
 - Carol would gain 55 happiness units by sitting next to David.
 - David would gain 46 happiness units by sitting next to Alice.
 - David would lose 7 happiness units by sitting next to Bob.
 - David would gain 41 happiness units by sitting next to Carol.

Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David talks so much), but David
would gain 46 happiness units (because Alice is such a good listener), for a total change of 44.

If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice gains 54). Finally,
seat Carol, who sits next to Bob (Carol gains 60, Bob loses 7) and David (Carol gains 55, David gains 41). The
arrangement looks like this:

     +41 +46
+55   David    -2
Carol       Alice
+60    Bob    +54
     -7  +83

After trying every other seating arrangement in this hypothetical scenario, you find that this one is the most
optimal, with a total change in happiness of 330.

What is the total change in happiness for the optimal seating arrangement of the actual guest list?

--- Part Two ---

In all the commotion, you realize that you forgot to seat yourself. At this point, you're pretty apathetic toward the whole thing, and your happiness wouldn't really go up or down regardless of who you sit next to. You assume everyone else would be just as ambivalent about sitting next to you, too.

So, add yourself to the list, and give all happiness relationships that involve you a score of 0.

What is the total change in happiness for the optimal seating arrangement that actually includes yourself?

=end

require_relative '../util'

class HolidayFeast
  def initialize(happiness_changes)
    @attendees = Set.new
    @happiness_changes = {}
    happiness_changes.split("\n").each do |change|
      raise(change) unless change =~ /^(\w+) would (gain|lose) (\d+) happiness units? by sitting next to (\w+)\.$/
      add_attendee($1)
      amount = $3.to_i
      amount = -amount if $2 == 'lose'
      @happiness_changes[[$1, $4]] = amount
    end
  end

  def add_attendee(attendee)
    @attendees << attendee
  end

  def happiness_change(attendee1, attendee2)
    @happiness_changes[[attendee1, attendee2]] || 0
  end

  def total_happiness_change(seating_arrangement)
    len = seating_arrangement.length
    (0...len).sum do |i|
      attendee = seating_arrangement[i]
      neighbors = [(i-1) % len, (i+1) % len].uniq # if len == 2, each attendee only has one neighbor!
      neighbors.sum { |j| happiness_change(attendee, seating_arrangement[j]) }
    end
  end

  def optimal_seating_arrangement
    @attendees.to_a.permutation.max_by(&method(:total_happiness_change))
  end
end

if defined? DATA
  feast = HolidayFeast.new(DATA.read.chomp)
  puts seating = feast.optimal_seating_arrangement
  puts feast.total_happiness_change(seating)

  feast.add_attendee('Doug')
  puts seating = feast.optimal_seating_arrangement
  puts feast.total_happiness_change(seating)
end

__END__
Alice would lose 2 happiness units by sitting next to Bob.
Alice would lose 62 happiness units by sitting next to Carol.
Alice would gain 65 happiness units by sitting next to David.
Alice would gain 21 happiness units by sitting next to Eric.
Alice would lose 81 happiness units by sitting next to Frank.
Alice would lose 4 happiness units by sitting next to George.
Alice would lose 80 happiness units by sitting next to Mallory.
Bob would gain 93 happiness units by sitting next to Alice.
Bob would gain 19 happiness units by sitting next to Carol.
Bob would gain 5 happiness units by sitting next to David.
Bob would gain 49 happiness units by sitting next to Eric.
Bob would gain 68 happiness units by sitting next to Frank.
Bob would gain 23 happiness units by sitting next to George.
Bob would gain 29 happiness units by sitting next to Mallory.
Carol would lose 54 happiness units by sitting next to Alice.
Carol would lose 70 happiness units by sitting next to Bob.
Carol would lose 37 happiness units by sitting next to David.
Carol would lose 46 happiness units by sitting next to Eric.
Carol would gain 33 happiness units by sitting next to Frank.
Carol would lose 35 happiness units by sitting next to George.
Carol would gain 10 happiness units by sitting next to Mallory.
David would gain 43 happiness units by sitting next to Alice.
David would lose 96 happiness units by sitting next to Bob.
David would lose 53 happiness units by sitting next to Carol.
David would lose 30 happiness units by sitting next to Eric.
David would lose 12 happiness units by sitting next to Frank.
David would gain 75 happiness units by sitting next to George.
David would lose 20 happiness units by sitting next to Mallory.
Eric would gain 8 happiness units by sitting next to Alice.
Eric would lose 89 happiness units by sitting next to Bob.
Eric would lose 69 happiness units by sitting next to Carol.
Eric would lose 34 happiness units by sitting next to David.
Eric would gain 95 happiness units by sitting next to Frank.
Eric would gain 34 happiness units by sitting next to George.
Eric would lose 99 happiness units by sitting next to Mallory.
Frank would lose 97 happiness units by sitting next to Alice.
Frank would gain 6 happiness units by sitting next to Bob.
Frank would lose 9 happiness units by sitting next to Carol.
Frank would gain 56 happiness units by sitting next to David.
Frank would lose 17 happiness units by sitting next to Eric.
Frank would gain 18 happiness units by sitting next to George.
Frank would lose 56 happiness units by sitting next to Mallory.
George would gain 45 happiness units by sitting next to Alice.
George would gain 76 happiness units by sitting next to Bob.
George would gain 63 happiness units by sitting next to Carol.
George would gain 54 happiness units by sitting next to David.
George would gain 54 happiness units by sitting next to Eric.
George would gain 30 happiness units by sitting next to Frank.
George would gain 7 happiness units by sitting next to Mallory.
Mallory would gain 31 happiness units by sitting next to Alice.
Mallory would lose 32 happiness units by sitting next to Bob.
Mallory would gain 95 happiness units by sitting next to Carol.
Mallory would gain 91 happiness units by sitting next to David.
Mallory would lose 66 happiness units by sitting next to Eric.
Mallory would lose 75 happiness units by sitting next to Frank.
Mallory would lose 99 happiness units by sitting next to George.
