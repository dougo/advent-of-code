require 'test-helper'
require '2023/day-11-cosmic-expansion'

class TestCosmicExpansion < Minitest::Test
  def setup
    @subject = SpaceImage.new <<END
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
END
  end

  def test_parsing
    assert_equal 9, @subject.galaxies.length
    assert_equal [3, 7], @subject.empty_rows
    assert_equal [2, 5, 8], @subject.empty_cols
  end

  def test_shortest_path_length
    galaxies = @subject.galaxies
    assert_equal 9,  @subject.shortest_path_length(galaxies[4], galaxies[8])
    assert_equal 15, @subject.shortest_path_length(galaxies[0], galaxies[6])
    assert_equal 17, @subject.shortest_path_length(galaxies[2], galaxies[5])
    assert_equal 5,  @subject.shortest_path_length(galaxies[7], galaxies[8])
    assert_equal 5,  @subject.shortest_path_length(galaxies[8], galaxies[7])
  end

  def test_sum_of_shortest_path_lengths
    assert_equal 374, @subject.sum_of_shortest_path_lengths
    assert_equal 1030, @subject.sum_of_shortest_path_lengths(10)
    assert_equal 8410, @subject.sum_of_shortest_path_lengths(100)
  end
end
