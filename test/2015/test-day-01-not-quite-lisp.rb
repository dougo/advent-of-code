require 'test-helper'
require '2015/day-01-not-quite-lisp'

class TestDay1NotQuiteLisp < Minitest::Test
  def setup
    @subject = Santa.new
  end

  def test_what_floor
    # (()) and ()() both result in floor 0.
    assert_equal 0, @subject.what_floor('(())')
    assert_equal 0, @subject.what_floor('()()')

    # ((( and (()(()( both result in floor 3.
    assert_equal 3, @subject.what_floor('(((')
    assert_equal 3, @subject.what_floor('(()(()(')

    # ))((((( also results in floor 3.
    assert_equal 3, @subject.what_floor('))(((((')

    # ()) and ))( both result in floor -1 (the first basement level).
    assert_equal (-1), @subject.what_floor('())')
    assert_equal (-1), @subject.what_floor('))(')

    # ))) and )())()) both result in floor -3.
    assert_equal (-3), @subject.what_floor(')))')
    assert_equal (-3), @subject.what_floor(')())())')
  end

  def test_position_of_basement_instruction
    # ) causes him to enter the basement at character position 1.
    assert_equal 1, @subject.position_of_basement_instruction(')')

    # ()()) causes him to enter the basement at character position 5.
    assert_equal 5, @subject.position_of_basement_instruction('()())')
  end
end
