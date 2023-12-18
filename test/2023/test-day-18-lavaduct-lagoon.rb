require 'test-helper'
require '2023/day-18-lavaduct-lagoon'

class TestLavaductLagoon < Minitest::Test

  def setup
    @input = <<END
R 6 (#70c710)
D 5 (#0dc571)
L 2 (#5713f0)
D 2 (#d2c081)
R 2 (#59c680)
D 2 (#411b91)
L 5 (#8ceee2)
U 2 (#caa173)
L 1 (#1b58a2)
U 2 (#caa171)
R 2 (#7807d2)
U 3 (#a77fa3)
L 2 (#015232)
U 2 (#7a21e3)
END
    @subject = LavaductLagoon.parse(@input)
    @subject2 = LavaductLagoon.parse(@input, corrected: true)
  end

  def test_lava_area
    assert_equal 62, @subject.lava_area 
    assert_equal 952408144115, @subject2.lava_area
  end
end
