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
  end

  def test_num_plots_in_steps
    assert_equal 16, @subject.num_plots_in_steps(6)
  end
end
