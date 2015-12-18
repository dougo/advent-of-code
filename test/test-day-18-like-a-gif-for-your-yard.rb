require 'test-helper'
require 'day-18-like-a-gif-for-your-yard'

class TestDay18LikeAGIFForYourYard < Minitest::Test
  def setup
    @input = <<END
.#.#.#
...##.
#....#
..#...
#.#..#
####..
END
    @subject = LightGrid.new(@input)
  end

  def test_size
    assert_equal 6, @subject.size
  end

  def test_to_s
    assert_equal @input.chomp, @subject.to_s
  end

  def test_animate
    next_grids.each do |grid|
      assert_equal grid, @subject.animate.to_s
    end

    assert_equal @subject.to_s, LightGrid.new(@input).animate(4).to_s
    assert_equal 4, @subject.how_many_on?
  end

  def test_broken_corners
    @subject = BrokenCornersLightGrid.new(@input)
    first_grid, *next_grids = broken_corners_grids
    assert_equal first_grid, @subject.to_s

    next_grids.each do |grid|
      assert_equal grid, @subject.animate.to_s
    end
    assert_equal 17, @subject.how_many_on?
  end

  private

  def next_grids
    grids = <<END
..##..
..##.#
...##.
......
#.....
#.##..

..###.
......
..###.
......
.#....
.#....

...#..
......
...#..
..##..
......
......

......
......
..##..
..##..
......
......
END
    grids.chomp.split("\n\n")
  end

  def broken_corners_grids
    grids = <<END
##.#.#
...##.
#....#
..#...
#.#..#
####.#

#.##.#
####.#
...##.
......
#...#.
#.####

#..#.#
#....#
.#.##.
...##.
.#..##
##.###

#...##
####.#
..##.#
......
##....
####.#

#.####
#....#
...#..
.##...
#.....
#.#..#

##.###
.##..#
.##...
.##...
#.#...
##...#
END
    grids.chomp.split("\n\n")
  end
end
