=begin

--- Day 20: Infinite Elves and Infinite Houses ---

To keep the Elves busy, Santa has them deliver some presents by hand, door-to-door. He sends them down a street
with infinite houses numbered sequentially: 1, 2, 3, 4, 5, and so on.

Each Elf is assigned a number, too, and delivers presents to houses based on that number:

 - The first Elf (number 1) delivers presents to every house: 1, 2, 3, 4, 5, ....
 - The second Elf (number 2) delivers presents to every second house: 2, 4, 6, 8, 10, ....
 - Elf number 3 delivers presents to every third house: 3, 6, 9, 12, 15, ....

There are infinitely many Elves, numbered starting with 1. Each Elf delivers presents equal to ten times his or her
number at each house.

So, the first nine houses on the street end up like this:

House 1 got 10 presents.
House 2 got 30 presents.
House 3 got 40 presents.
House 4 got 70 presents.
House 5 got 60 presents.
House 6 got 120 presents.
House 7 got 80 presents.
House 8 got 150 presents.
House 9 got 130 presents.

The first house gets 10 presents: it is visited only by Elf 1, which delivers 1 * 10 = 10 presents. The fourth
house gets 70 presents, because it is visited by Elves 1, 2, and 4, for a total of 10 + 20 + 40 = 70 presents.

What is the lowest house number of the house to get at least as many presents as the number in your puzzle input?

--- Part Two ---

The Elves decide they don't want to visit an infinite number of houses. Instead, each Elf will stop after
delivering presents to 50 houses. To make up for it, they decide to deliver presents equal to eleven times their
number at each house.

With these changes, what is the new lowest house number of the house to get at least as many presents as the number
in your puzzle input?

=end


require 'set'
require_relative 'util'

class Integer
  def delivers_presents_to?(house)
    # Elf N visits every Nth house, so it visits a house iff N evenly divides the house number.
    house % self == 0
  end

  def elves
    # The elves that visited a house correspond to the factors of the house number.
    # TODO: use Prime#prime_division ?
    low_elves = (1..Math.sqrt(self)).select { |elf| elf.delivers_presents_to?(self) }

    # Every low elf has a high elf who also visited this house, except for elf sqrt(self)...
    high_elves = low_elves.map { |elf| self / elf }.reverse
    if low_elves.last == high_elves.first
      low_elves + high_elves.drop(1)
    else
      low_elves + high_elves
    end
  end

  def presents
    elves.sum * 10
  end
end

def lowest_house_number_to_get_at_least(n)
  (1..n).find { |house| house.presents >= n }
end

if defined? DATA
  puts lowest_house_number_to_get_at_least(DATA.read.to_i)
end

__END__
36000000
