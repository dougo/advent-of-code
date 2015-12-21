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

require 'prime'
require_relative 'util'

class Integer
  def elves(max_houses_per_elf: Float::INFINITY)
    # Each elf N visits all houses M*N. Thus each house is visited by each elf whose number can evenly divide the
    # house number. In other words, the elves that visit a house H correspond to the factors of H.

    if max_houses_per_elf <= Math.sqrt(self)
      # We only need to look at max_houses_per_elf potential elves, from H/1 down to H/max_houses_per_elf,
      # because any elf whose number is smaller than that would have stopped before getting to H.
      # (Thanks to Michael C. Martin for this insight!)
      return (1..max_houses_per_elf).select { |d| self % d == 0 }.map { |d| self/d }.reverse
    end

    # Compute all factors of H based on its prime factorization, using Integer#prime_division.
    # The code below is adapted from: http://stackoverflow.com/a/3398195/2418704
    return [1] if self == 1
    primes, powers = prime_division.transpose
    exponents = powers.map { |i| (0..i).to_a }
    exponents.shift.product(*exponents).map do |powers|
      Integer.from_prime_division(primes.zip(powers))
    end.sort.drop_while { |elf| elf * max_houses_per_elf < self }
  end

  def presents(presents_per_elf: 10, **rest)
    elves(**rest).sum * presents_per_elf
  end
end

def lowest_house_number_to_get_at_least(n, **opts)
  (1..n).find { |house| house.presents(**opts) >= n }
end

if defined? DATA
  min_presents = DATA.read.to_i
  puts lowest_house_number_to_get_at_least(min_presents)
  puts lowest_house_number_to_get_at_least(min_presents, max_houses_per_elf: 50, presents_per_elf: 11)
end

__END__
36000000
