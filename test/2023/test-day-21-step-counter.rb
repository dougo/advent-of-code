require 'test-helper'
require '2023/day-21-step-counter'

class TestStepCounter < Minitest::Test
  def setup
    @input = <<END
...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........
END
    @subject = StepCounter.parse(@input)
    @subject2 = StepCounter.parse(@input, infinite: true)
  end

  def test_num_plots_in_steps
    assert_equal 6, @subject.num_plots_in_steps(3)
    assert_equal 16, @subject.num_plots_in_steps(6)
    assert_equal 33, @subject.num_plots_in_steps(10)
  end

  def test_infinite_grid
    assert_predicate @subject2, :infinite?
    assert_equal 6, @subject2.num_plots_in_steps(3)
    assert_equal 16, @subject2.num_plots_in_steps(6)
    assert_equal 50, @subject2.num_plots_in_steps(10)
    assert_equal 1594, @subject2.num_plots_in_steps(50)
    assert_equal 6536, @subject2.num_plots_in_steps(100)
    skip
    assert_equal 167004, @subject2.num_plots_in_steps(500)
    assert_equal 668697, @subject2.num_plots_in_steps(1000)
    assert_equal 16733044, @subject2.num_plots_in_steps(5000)
  end
end
