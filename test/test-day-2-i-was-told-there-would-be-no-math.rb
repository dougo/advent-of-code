require 'test-helper'
require 'day-2-i-was-told-there-would-be-no-math'

class TestDay2IWasToldThereWouldBeNoMath < Minitest::Test
  def test_wrapping_paper_needed
    # A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 square feet of wrapping paper plus 6 square
    # feet of slack, for a total of 58 square feet.
    assert_equal 58, Present.new('2x3x4').wrapping_paper_needed

    # A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 square feet of wrapping paper plus 1 square
    # foot of slack, for a total of 43 square feet.
    assert_equal 43, Present.new('1x1x10').wrapping_paper_needed
  end
end
