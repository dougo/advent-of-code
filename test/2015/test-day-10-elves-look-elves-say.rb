require 'test-helper'
require '2015/day-10-elves-look-elves-say'

class TestDay10ElvesLookElvesSay < Minitest::Test
  def setup
    @subject = Elves.new('1')
  end

  def test_look_and_say
    # 1 becomes 11 (1 copy of digit 1).
    assert_equal '11', @subject.look_and_say

    # 11 becomes 21 (2 copies of digit 1).
    assert_equal '21', @subject.look_and_say

    # 21 becomes 1211 (one 2 followed by one 1).
    assert_equal '1211', @subject.look_and_say

    # 1211 becomes 111221 (one 1, one 2, and two 1s).
    assert_equal '111221', @subject.look_and_say

    # 111221 becomes 312211 (three 1s, two 2s, and one 1).
    assert_equal '312211', @subject.look_and_say
  end

  def test_repeated_look_and_say
    assert_equal '312211', @subject.look_and_say(5)
  end
end
