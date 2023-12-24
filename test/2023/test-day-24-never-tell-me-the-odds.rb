require 'test-helper'
require 'matrix'
require '2023/day-24-never-tell-me-the-odds'

class TestNeverTellMeTheOdds < Minitest::Test
  def setup
    @input = <<END
19, 13, 30 @ -2,  1, -2
18, 19, 22 @ -1, -1, -2
20, 25, 34 @ -2, -2, -4
12, 31, 28 @ -1, -2, -1
20, 19, 15 @  1, -5, -3
END
    @subject = NeverTellMeTheOdds.parse(@input)
  end

  def test_paths_cross
    a, b = @subject.hailstones.values_at(0, 1)
    assert_equal Vector[14+1/3r, 15+1/3r], @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(0, 2)
    assert_equal Vector[11+2/3r, 16+2/3r], @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(0, 3)
    assert_equal Vector[6.2, 19.4], @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(0, 4)
    times = @subject.times_when_paths_cross(a, b)
    assert_predicate times[0], :negative?

    a, b = @subject.hailstones.values_at(1, 2)
    assert_nil @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(1, 3)
    assert_equal Vector[-6, -5], @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(1, 4)
    times = @subject.times_when_paths_cross(a, b)
    assert_predicate times[0], :negative?
    assert_predicate times[1], :negative?

    a, b = @subject.hailstones.values_at(2, 3)
    assert_equal Vector[-2, 3], @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(2, 4)
    times = @subject.times_when_paths_cross(a, b)
    assert_predicate times[1], :negative?

    a, b = @subject.hailstones.values_at(3, 4)
    times = @subject.times_when_paths_cross(a, b)
    assert_predicate times[0], :negative?
    assert_predicate times[1], :negative?
  end

  def test_num_intersections_in_test_area
    assert_equal 2, @subject.num_intersections_in_test_area(7..27)
  end
end
