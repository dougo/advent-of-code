require 'test-helper'
require '2023/day-9-mirage-maintenance'

class TestMirageMaintenance < Minitest::Test
  def setup
    @subject = OasisReport.new <<END
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
END
  end

  def test_extrapolated_values
    assert_equal [18, 28, 68], @subject.extrapolated_values
  end

  def test_sum_of_extrapolated_values
    assert_equal 114, @subject.sum_of_extrapolated_values
  end

  def test_extrapolated_values_backwards
    assert_equal [-3, 0, 5], @subject.extrapolated_values_backwards
  end

  def test_sum_of_extrapolated_values_backwards
    assert_equal 2, @subject.sum_of_extrapolated_values_backwards
  end
end
