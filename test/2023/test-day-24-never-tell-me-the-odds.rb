require 'test-helper'
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
    pos = @subject.position_where_paths_cross(a, b)
    assert_equal [14+1/3r, 15+1/3r], [pos.x, pos.y]

    a, b = @subject.hailstones.values_at(0, 2)
    pos = @subject.position_where_paths_cross(a, b)
    assert_equal [11+2/3r, 16+2/3r], [pos.x, pos.y]

    a, b = @subject.hailstones.values_at(0, 3)
    pos = @subject.position_where_paths_cross(a, b)
    assert_equal [6.2, 19.4], [pos.x, pos.y]

    a, b = @subject.hailstones.values_at(0, 4)
    t_a, _ = @subject.times_when_paths_cross(a, b)
    assert_operator t_a, :<, 0

    a, b = @subject.hailstones.values_at(1, 2)
    assert_nil @subject.position_where_paths_cross(a, b)

    a, b = @subject.hailstones.values_at(1, 3)
    pos = @subject.position_where_paths_cross(a, b)
    assert_equal [-6, -5], [pos.x, pos.y]

    a, b = @subject.hailstones.values_at(1, 4)
    t_a, t_b = @subject.times_when_paths_cross(a, b)
    assert_operator t_a, :<, 0
    assert_operator t_b, :<, 0

    a, b = @subject.hailstones.values_at(2, 3)
    pos = @subject.position_where_paths_cross(a, b)
    assert_equal [-2, 3], [pos.x, pos.y]

    a, b = @subject.hailstones.values_at(2, 4)
    _, t_b = @subject.times_when_paths_cross(a, b)
    assert_operator t_b, :<, 0

    a, b = @subject.hailstones.values_at(3, 4)
    t_a, t_b = @subject.times_when_paths_cross(a, b)
    assert_operator t_a, :<, 0
    assert_operator t_b, :<, 0
  end

  def test_num_intersections_in_test_area
    assert_equal 2, @subject.num_intersections_in_test_area(7..27)
  end
end
