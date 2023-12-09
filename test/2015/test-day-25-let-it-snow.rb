require 'test-helper'
require 'day-25-let-it-snow'

class TestDay25LetItSnow < Minitest::Test
  def setup
    @input = <<END
To continue, please consult the code grid in the manual.  Enter the code at row 6, column 5.
END
    @subject = WeatherMachine.parse(@input)
  end

  def test_next_code
    # So, to find the second code (which ends up in row 2, column 1), start with the previous value,
    # 20151125. Multiply it by 252533 to get 5088824049625. Then, divide that by 33554393, which leaves a remainder
    # of 31916031. That remainder is the second code.
    assert_equal 31916031, @subject.next_code(20151125)
  end

  def test_code_at
    codes = [[20151125,  18749137,  17289845,  30943339,  10071777,  33511524],
             [31916031,  21629792,  16929656,   7726640,  15514188,   4041754],
             [16080970,   8057251,   1601130,   7981243,  11661866,  16474243],
             [24592653,  32451966,  21345942,   9380097,  10600672,  31527494],
             [   77061,  17552253,  28094349,   6899651,   9250759,  31663883],
             [33071741,   6796745,  25397450,  24659492,   1534922,  27995004]]

    codes.each_with_index do |row, r|
      row.each_with_index do |code, c|
        assert_equal code, @subject.code_at(r+1, c+1)
      end
    end
  end

  def test_code
    assert_equal 1534922, @subject.code
  end
end
