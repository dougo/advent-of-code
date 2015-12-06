require 'test-helper'
require 'day-1-not-quite-lisp'

class TestDay1NotQuiteLisp < Minitest::Test
  def test_what_floor
    @subject = Santa.new

    # (()) and ()() both result in floor 0.
    assert_equal 0, @subject.what_floor('(())')
    assert_equal 0, @subject.what_floor('()()')

    # ((( and (()(()( both result in floor 3.
    assert_equal 3, @subject.what_floor('(((')
    assert_equal 3, @subject.what_floor('(()(()(')

    # ))((((( also results in floor 3.
    assert_equal 3, @subject.what_floor('))(((((')

    # ()) and ))( both result in floor -1 (the first basement level).
    assert_equal -1, @subject.what_floor('())')
    assert_equal -1, @subject.what_floor('))(')

    # ))) and )())()) both result in floor -3.
    assert_equal -3, @subject.what_floor(')))')
    assert_equal -3, @subject.what_floor(')())())')
  end
end
