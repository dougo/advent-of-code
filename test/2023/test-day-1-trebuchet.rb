require 'test-helper'
require '2023/day-1-trebuchet'

class TestTrebuchet < Minitest::Test
  def setup
    @example = <<END
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
END
  end

  # In this example, the calibration values of these four lines are 12, 38, 15, and 77. Adding these together
  # produces 142.

  def test_calibration_line
    @subject = @example.lines(chomp: true)

    assert_equal 12, CalibrationLine.new(@subject[0]).value
    assert_equal 38, CalibrationLine.new(@subject[1]).value
    assert_equal 15, CalibrationLine.new(@subject[2]).value
    assert_equal 77, CalibrationLine.new(@subject[3]).value
  end

  def test_calibration_document
    @subject = CalibrationDocument.new(@example)

    assert_equal 142, @subject.sum
  end
end
