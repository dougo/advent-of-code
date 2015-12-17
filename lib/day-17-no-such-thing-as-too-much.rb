=begin

--- Day 17: No Such Thing as Too Much ---

The elves bought too much eggnog again - 150 liters this time. To fit it all into your refrigerator, you'll need to
move it into smaller containers. You take an inventory of the capacities of the available containers.

For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters. If you need to store 25 liters, there
are four ways to do it:

 - 15 and 10
 - 20 and 5 (the first 5)
 - 20 and 5 (the second 5)
 - 15, 5, and 5

Filling all containers entirely, how many different combinations of containers can exactly fit all 150 liters of
eggnog?

--- Part Two ---

While playing with all the containers in the kitchen, another load of eggnog arrives! The shipping and receiving
department is requesting as many containers as you can spare.

Find the minimum number of containers that can exactly fit all 150 liters of eggnog. How many different ways can
you fill that number of containers and still hold exactly 150 litres?

In the example above, the minimum number of containers was two. There were three ways to use that many containers,
and so the answer there would be 3.

=end

class EggnogContainers
  def initialize(input)
    @sizes = input.split.map &:to_i
  end

  attr_reader :sizes

  def ways_to_fit(eggnog, sizes = @sizes)
    return [[]] if eggnog == 0
    return [] if sizes.empty?
    size, *rest = sizes
    leftover = eggnog - size
    ways = ways_to_fit(eggnog, rest)
    if leftover >= 0
      ways_to_fit(leftover, rest).map { |sizes| [size, *sizes] } + ways
    else
      ways
    end
  end

  def efficient_ways_to_fit(eggnog)
    ways_to_fit(eggnog).sort_by(&:length).chunk(&:length).first[1]
  end
end

if defined? DATA
  containers = EggnogContainers.new(DATA.read)
  p containers.ways_to_fit(150).length
  p containers.efficient_ways_to_fit(150).length
end

__END__
43
3
4
10
21
44
4
6
47
41
34
17
17
44
36
31
46
9
27
38
