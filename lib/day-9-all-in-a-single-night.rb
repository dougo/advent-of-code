=begin

--- Day 9: All in a Single Night ---

Every year, Santa manages to deliver all of his presents in a single night.

This year, however, he has some new locations to visit; his elves have provided him the distances between every
pair of locations. He can start and end at any two (different) locations he wants, but he must visit each location
exactly once. What is the shortest distance he can travel to achieve this?

For example, given the following distances:

London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141

The possible routes are therefore:

Dublin -> London -> Belfast = 982
London -> Dublin -> Belfast = 605
London -> Belfast -> Dublin = 659
Dublin -> Belfast -> London = 659
Belfast -> Dublin -> London = 605
Belfast -> London -> Dublin = 982

The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.

What is the distance of the shortest route?

--- Part Two ---

The next year, just to show off, Santa decides to take the route with the longest distance instead.

He can still start and end at any two (different) locations he wants, and he still must visit each location exactly once.

For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London -> Belfast.

What is the distance of the longest route?

=end

require 'set'

class SantaMap
  def initialize(distances)
    @locations = Set.new
    @distances = {}
    distances.split("\n").each &method(:add_distance)
  end

  def routes
    @locations.to_a.permutation.to_a.sort_by(&method(:route_distance))
  end

  def shortest_route
    routes.first
  end

  def longest_route
    routes.last
  end

  def route_distance(route)
    route[0..-2].zip(route[1..-1]).map(&method(:distance)).reduce(:+)
  end

  private

  def add_distance(distance)
    distance =~ /^(\w+) to (\w+) = (\d+)$/
    @locations << $1 << $2
    @distances[[$1,$2]] = $3.to_i
  end

  def distance(loc_pair)
    loc1, loc2 = loc_pair
    @distances[[loc1, loc2]] || @distances[[loc2, loc1]]
  end
end

if defined? DATA
  input = DATA.read
  map = SantaMap.new(input)
  route = map.shortest_route
  puts route.join(' -> ')
  puts map.route_distance(route)
  route = map.longest_route
  puts route.join(' -> ')
  puts map.route_distance(route)
end

__END__
Faerun to Norrath = 129
Faerun to Tristram = 58
Faerun to AlphaCentauri = 13
Faerun to Arbre = 24
Faerun to Snowdin = 60
Faerun to Tambi = 71
Faerun to Straylight = 67
Norrath to Tristram = 142
Norrath to AlphaCentauri = 15
Norrath to Arbre = 135
Norrath to Snowdin = 75
Norrath to Tambi = 82
Norrath to Straylight = 54
Tristram to AlphaCentauri = 118
Tristram to Arbre = 122
Tristram to Snowdin = 103
Tristram to Tambi = 49
Tristram to Straylight = 97
AlphaCentauri to Arbre = 116
AlphaCentauri to Snowdin = 12
AlphaCentauri to Tambi = 18
AlphaCentauri to Straylight = 91
Arbre to Snowdin = 129
Arbre to Tambi = 53
Arbre to Straylight = 40
Snowdin to Tambi = 15
Snowdin to Straylight = 99
Tambi to Straylight = 70
