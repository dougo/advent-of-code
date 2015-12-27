require 'test-helper'
require 'day-24-it-hangs-in-the-balance'

class TestDay24ItHangsInTheBalance < Minitest::Test
  def setup
    @input = <<END
1
2
3
4
5
7
8
9
10
11
END
    @subject = PackageList.parse(@input)
  end

  def test_trisections
    assert_equal [[11, 9], 99, [10, 8, 2], [7, 5, 4, 3, 1]], @subject.trisections
  end

  def test_quadrisections
    assert_equal [[11, 4], 44, [10, 5], [8, 7], [9, 3, 2, 1]], @subject.quadrisections
  end
end
