require 'test-helper'
require 'day-17-no-such-thing-as-too-much'

class TestDay17NoSuchThingAsTooMuch < Minitest::Test
  def test_parse_containers
    input = <<END
1
2
3
END
    assert_equal [1, 2, 3], EggnogContainers.new(input).sizes
  end

  def test_ways_to_fit
    # For example, suppose you have containers of size 20, 15, 10, 5, and 5 liters.
    containers = EggnogContainers.new('20 15 10 5 5')

    # If you need to store 25 liters, there are four ways to do it:
    # - 15 and 10
    # - 20 and 5 (the first 5)
    # - 20 and 5 (the second 5)
    # - 15, 5, and 5
    assert_equal [[20, 5], [20, 5], [15, 10], [15, 5, 5]], containers.ways_to_fit(25)
  end
end
