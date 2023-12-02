require 'test-helper'
require '2023/day-1-trebuchet'

class TestTrebuchet < Minitest::Test
  def test_calibration_line_part_1
    @part1 = <<END
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
END
    @subject = CalibrationDocument.new(@part1)

    # In this example, the calibration values of these four lines are 12, 38, 15, and 77.
    assert_equal [12, 38, 15, 77], @subject.values
    # Adding these together produces 142.
    assert_equal 142, @subject.sum
  end

  def test_calibration_line_part_2
    @part2 = <<END
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
END
    @subject = CalibrationDocument.new(@part2)

    # In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
    assert_equal [29, 83, 13, 24, 42, 14, 76], @subject.values
    # Adding these together produces 281.
    assert_equal 281, @subject.sum
  end
end
