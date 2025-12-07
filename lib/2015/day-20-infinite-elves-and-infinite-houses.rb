require 'prime'
require_relative '../util'

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
