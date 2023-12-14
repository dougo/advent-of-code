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
    assert_equal tilted.lines(chomp: true), @subject.tilt(:north).lines
  end

  def test_total_load_when_tilted_north
    assert_equal 136, @subject.total_load_when_tilted(:north)
  end

  def test_cycle
    cycled_once = <<END
.....#....
....#...O#
...OO##...
.OO#......
.....OOO#.
.O#...O#.#
....O#....
......OOOO
#...O###..
#..OO#....
END

    cycled_twice = <<END
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#..OO###..
#.OOO#...O
END

    cycled_thrice = <<END
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#...O###.O
#.OOO#...O
END

    assert_equal cycled_once.lines(chomp: true), @subject.cycle.lines
    assert_equal cycled_twice.lines(chomp: true), @subject.cycle.cycle.lines
    assert_equal cycled_thrice.lines(chomp: true), @subject.cycle.cycle.cycle.lines
  end

  def test_cycle_a_billion_times
    assert_equal 64, @subject.cycle_a_billion_times.total_load
  end
end
