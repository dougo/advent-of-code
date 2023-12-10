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
  end

  def test_farthest_distance_by_pipes
    assert_equal 8, @subject.farthest_distance_by_pipes
  end
end
