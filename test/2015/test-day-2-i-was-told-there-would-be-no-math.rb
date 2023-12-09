require 'test-helper'
require '2015/day-2-i-was-told-there-would-be-no-math'

class TestDay2IWasToldThereWouldBeNoMath < Minitest::Test
  def setup
    @list_of_dimensions = <<END
2x3x4
1x1x10
END
    @dimensions1, @dimensions2 = @list_of_dimensions.split
  end

  def test_wrapping_paper_needed
    # A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 square feet of wrapping paper plus 6 square
    # feet of slack, for a total of 58 square feet.
    assert_equal 58, Present.new(@dimensions1).wrapping_paper_needed

    # A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 square feet of wrapping paper plus 1 square
    # foot of slack, for a total of 43 square feet.
    assert_equal 43, Present.new(@dimensions2).wrapping_paper_needed
  end

  def test_total_wrapping_paper_needed
    assert_equal 101, Present.total_wrapping_paper_needed(@list_of_dimensions)
  end

  def test_ribbon_needed
    # A present with dimensions 2x3x4 requires 2+2+3+3 = 10 feet of ribbon to wrap the present plus 2*3*4 = 24 feet
    # of ribbon for the bow, for a total of 34 feet.
    assert_equal 34, Present.new(@dimensions1).ribbon_needed

    # A present with dimensions 1x1x10 requires 1+1+1+1 = 4 feet of ribbon to wrap the present plus 1*1*10 = 10
    # feet of ribbon for the bow, for a total of 14 feet.
    assert_equal 14, Present.new(@dimensions2).ribbon_needed
  end
  
  def test_total_ribbon_needed
    assert_equal 48, Present.total_ribbon_needed(@list_of_dimensions)
  end
end
