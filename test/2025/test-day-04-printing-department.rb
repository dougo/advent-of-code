require 'test-helper'
require '2025/day-04-printing-department'

class TestPrintingDepartment < Minitest::Test
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
    @subject = PrintingDepartment.parse(@input)
  end

  def test_part_1
    assert_equal 13, @subject.num_accessible_positions
  end

  def test_part_2
    assert_equal 43, @subject.num_recursively_accessible_positions
  end
end
