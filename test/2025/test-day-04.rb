require 'test-helper'
require '2025/day-04'

class TestDay04 < Minitest::Test
  def setup
    @input = <<END
..@@.@@@@.
@@@.@.@.@@
@@@@@.@.@@
@.@@@@..@.
@@.@@@@.@@
.@@@@@@@.@
.@.@.@.@@@
@.@@@.@@@@
.@@@@@@@@.
@.@.@@@.@.
END
    @subject = Day04.new(@input)
  end

  def test_part_1
    assert_equal 13, @subject.part_1
  end
end
