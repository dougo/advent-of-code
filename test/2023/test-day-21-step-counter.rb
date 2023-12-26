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
    assert_equal 6, @subject.num_plots_in_steps(3)
    assert_equal 16, @subject.num_plots_in_steps(6)
    assert_equal 33, @subject.num_plots_in_steps(10)
    assert_equal 42, @subject.num_plots_in_steps(14)
    assert_equal 39, @subject.num_plots_in_steps(15)
    assert_equal 42, @subject.num_plots_in_steps(16)
    assert_equal 39, @subject.num_plots_in_steps(17)
  end

  def test_even?
    assert @subject.even?(Position[0,0])
    refute @subject.even?(Position[0,1])

    offcenter = StepCounter.parse('...S')
    refute offcenter.even?(Position[0,0])
    assert offcenter.even?(Position[0,1])
  end

  def test_infinite_grid
    assert_equal 6, @subject.num_plots_in_steps(3, infinite: true)
    assert_equal 16, @subject.num_plots_in_steps(6, infinite: true)
    assert_equal 41, @subject.num_plots_in_steps(9, infinite: true)
    assert_equal 50, @subject.num_plots_in_steps(10, infinite: true)
    assert_equal 1594, @subject.num_plots_in_steps(50, infinite: true)
    assert_equal 6536, @subject.num_plots_in_steps(100, infinite: true)
    assert_equal 167004, @subject.num_plots_in_steps(500, infinite: true)
    assert_equal 668697, @subject.num_plots_in_steps(1000, infinite: true)
    assert_equal 16733044, @subject.num_plots_in_steps(5000, infinite: true)
  end
end
