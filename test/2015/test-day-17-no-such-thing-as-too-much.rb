require 'test-helper'
require '2015/day-17-no-such-thing-as-too-much'

class TestDay17NoSuchThingAsTooMuch < Minitest::Test
  def setup
    input = <<END
20
15
10
5
5
END
    @subject = EggnogContainers.new(input)
  end

  def test_sizes
    assert_equal [20,15,10,5,5], @subject.sizes
  end

  def test_ways_to_fit
    # If you need to store 25 liters, there are four ways to do it:
    # - 15 and 10
    # - 20 and 5 (the first 5)
    # - 20 and 5 (the second 5)
    # - 15, 5, and 5
    assert_equal [[20, 5], [20, 5], [15, 10], [15, 5, 5]], @subject.ways_to_fit(25)
  end

  def test_efficient_ways_to_fit
    # In the example above, the minimum number of containers was two. There were three ways to use that many
    # containers, and so the answer there would be 3.
    assert_equal [[20, 5], [20, 5], [15, 10]], @subject.efficient_ways_to_fit(25)
  end
end
