require 'test-helper'
require '2016/day-01-no-time-for-a-taxicab'

class TestNoTimeForATaxicab < Minitest::Test
  def setup
    @input = <<END
R5, L5, R5, R3
END
    @subject = NoTimeForATaxicab.parse(@input)
  end

  def test_blocks_away
    assert_equal 12, @subject.blocks_away
    assert_equal 100, NoTimeForATaxicab.parse('R100').blocks_away
  end
end
