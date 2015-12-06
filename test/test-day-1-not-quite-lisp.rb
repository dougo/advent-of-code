require 'test-helper'
require 'day-1-not-quite-lisp'

class TestDay1NotQuiteLisp < Minitest::Test
  def test_what_floor
    @subject = Santa.new
    assert_equal 0, @subject.what_floor('(())')
    assert_equal 0, @subject.what_floor('()()')
  end
end
