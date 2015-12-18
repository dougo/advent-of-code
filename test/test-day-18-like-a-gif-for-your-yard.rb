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

  def test_on?
    assert @subject.on?(0, 3)
    assert @subject.on?(4, 5)
    refute @subject.on?(2, 2)
    refute @subject.on?(-1, 2)
    refute @subject.on?(2, -1)
    refute @subject.on?(6, 2)
    refute @subject.on?(2, 6)
  end

  def test_num_neighbors_on
    assert_equal 3, @subject.num_neighbors_on(2, 4) # light is off
    assert_equal 2, @subject.num_neighbors_on(1, 3) # light is on
    assert_equal 4, @subject.num_neighbors_on(0, 4) # edge light
    assert_equal 1, @subject.num_neighbors_on(5, 5) # corner light
  end

  def test_next_on?
    assert @subject.next_on?(1, 3) # on, 2 neighbors
    assert @subject.next_on?(5, 2) # on, 3 neighbors
    assert @subject.next_on?(2, 4) # off, 3 neighbors
    refute @subject.next_on?(3, 5) # off, 2 neighbors
    refute @subject.next_on?(1, 4) # on, 4 neighbors
  end

  def test_animate
    next_grids.each do |grid|
      assert_equal grid, @subject.animate.to_s
    end

    assert_equal @subject.to_s, LightGrid.new(@input).animate(4).to_s
    assert_equal 4, @subject.num_on
  end

  def test_broken_corners
    @subject = BrokenCornersLightGrid.new(@input)

    assert_equal [[0,0], [0,5], [5,0], [5,5]], @subject.corner_coords

    first_grid, *next_grids = broken_corners_grids
    assert_equal first_grid, @subject.to_s

    @subject.corner_coords.each { |r, c| assert @subject.next_on?(r, c) }
    refute @subject.next_on?(3, 5)

    next_grids.each do |grid|
      assert_equal grid, @subject.animate.to_s
    end
    assert_equal 17, @subject.num_on
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
