require 'test-helper'
require 'util'

class TestUtil < Minitest::Test
  def test_index_by
    assert_equal({}, [].index_by {})
    assert_equal({ 1 => 1, 2 => 2 }, [1, 2].index_by { |x| x })
    assert_equal({ 1 => 1, 2 => 2 }, (1..2).index_by { |x| x })    
    assert_equal({ 1 => 1, 2 => 2 }, [1, 2, 1].index_by { |x| x })
    assert_equal({ a: 'a', b: 'b' }, %w(a b b).index_by(&:to_sym))
  end

  def test_in?
    assert 2.in?(1..3)
    assert 'b'.in?(%w(a b c))
    refute 'x'.in?(%w(a b c))
  end

  def test_position
    pos = Position[23, 45]
    assert_equal Position[23, 56], pos.move(EAST, 11)
    assert_equal Position[23, -13], pos.move(WEST, 58)
    assert_equal Position[16, 45], pos.move(NORTH, 7)
    assert_equal Position[34, 45], pos.move(SOUTH, 11)
    assert_equal Position[24, 45], pos.move(SOUTH)
    assert_equal [Position[22, 45], Position[23, 46], Position[24, 45], Position[23, 44]], pos.neighbors
  end

  def test_direction
    assert_equal EAST, NORTH.turn_right
    assert_equal SOUTH, EAST.turn_right
    assert_equal WEST, NORTH.turn_left
    assert_equal SOUTH, WEST.turn_left
    assert_equal NORTH, EAST.turn(-1)
    assert_equal SOUTH, EAST.turn(+1)
  end
end
