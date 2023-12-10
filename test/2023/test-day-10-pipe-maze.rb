require 'test-helper'
require '2023/day-10-pipe-maze'

class TestPipeMaze < Minitest::Test
  def setup
    @subject = PipeMaze.new <<END
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
END
    @subject2 = PipeMaze.new <<END
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
END
  end

  def test_farthest_distance_by_pipes
    assert_equal 8, @subject.farthest_distance_by_pipes
  end

  def test_area_enclosed_by_pipes
    assert_equal 1, @subject.area_enclosed_by_pipes
    assert_equal 10, @subject2.area_enclosed_by_pipes
  end
end
