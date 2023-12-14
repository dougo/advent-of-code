require 'test-helper'
require '2023/day-14-parabolic-reflector-dish'

class TestParabolicReflectorDish < Minitest::Test
  def setup
    @subject = ParabolicReflectorDish.parse <<END
O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....
END
  end

  def test_tilt_north
    tilted = <<END
OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....
END
    assert_equal tilted.lines(chomp: true), @subject.tilt_north.lines
  end

  def test_total_load_when_tilted_north
    assert_equal 136, @subject.total_load_when_tilted_north
  end
end
