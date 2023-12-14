require 'test-helper'
require '2015/day-03-perfectly-spherical-houses-in-a-vacuum'

class TestDay3PerfectlySphericalHousesInAVacuum < Minitest::Test
  def test_houses_visited
    # > delivers presents to 2 houses: one at the starting location, and one to the east.
    assert_equal 2, Santa.new.houses_visited('>')

    # ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
    assert_equal 4, Santa.new.houses_visited('^>v<')

    # ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.
    assert_equal 2, Santa.new.houses_visited('^v^v^v^v^v')
  end

  def test_robo_santa
    # ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
    assert_equal 3, Santa.new.houses_visited_with_robo_santa('^v')

    # ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
    assert_equal 3, Santa.new.houses_visited_with_robo_santa('^>v<')

    #^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.
    assert_equal 11, Santa.new.houses_visited_with_robo_santa('^v^v^v^v^v')
  end
end
