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

  def test_grid
    grid = Grid.parse <<END
1234
ABCD
*.#@
END
    assert_equal 3, grid.height
    assert_equal 4, grid.width
    assert_equal 0...3, grid.row_range
    assert_equal 0...4, grid.col_range

    assert_includes grid, Position[1,2]
    refute_includes grid, Position[-1,2]
    refute_includes grid, Position[3,2]
    refute_includes grid, Position[1,-1]
    refute_includes grid, Position[1,4]
    assert_equal 'C', grid[Position[1,2]]
    assert_nil grid[Position[3,4]]

    grid[Position[1,2]] = 'Q'
    assert_equal 'ABQD', grid.rows[1]
    grid[Position[-2,2]] = 'Z'
    assert_equal 'ABQD', grid.rows[1]

    posns = []
    assert_same grid, grid.each_position { posns << _1 }
    assert_equal 12, posns.length
    assert_equal Position[0,0], posns[0]
    assert_equal Position[0,1], posns[1]
    assert_equal Position[2,3], posns[11]

    assert_equal posns, grid.each_position.to_a

    int_grid, float_grid = Grid.new([[2]]), Grid.new([[2.0]])
    assert_equal int_grid, float_grid
    refute_operator int_grid, :eql?, float_grid
    assert_operator Grid.new([[2]]), :eql?, int_grid
    assert_includes Set[int_grid], Grid.new([[2]])
    refute_includes Set[int_grid], float_grid

    copy = grid.dup
    refute_same grid, copy
    assert_equal grid, copy
    copy[Position[1,2]] = 'C'
    assert_equal 'ABQD', grid.rows[1]
  end
end
