require 'test-helper'
require 'day-3-perfectly-spherical-houses-in-a-vacuum'

class TestDay3PerfectlySphericalHousesInAVacuum < Minitest::Test
  def setup
    @subject = Santa.new
  end

  def test_houses_visited
    # > delivers presents to 2 houses: one at the starting location, and one to the east.
    assert_equal 2, @subject.houses_visited('>')

    # ^>v< delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
    assert_equal 4, @subject.houses_visited('^>v<')

    # ^v^v^v^v^v delivers a bunch of presents to some very lucky children at only 2 houses.
    assert_equal 2, @subject.houses_visited('^v^v^v^v^v')
  end
end
