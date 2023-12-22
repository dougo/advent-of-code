# These methods are shamelessly stolen from ActiveSupport!

module Enumerable
  # Convert to a hash, computing the indices with a given block.
  def index_by
    map { |x| [yield(x), x] }.to_h
  end
end

class Object
  def in?(things)
    things.include?(self)
  end
end

Position = Data.define(:row, :col) do
  def move(dir, dist=1) = self.class.new(row + dir.drow * dist, col + dir.dcol * dist)
  def neighbors = DIRECTIONS_CLOCKWISE.map { move(_1) }
end

Direction = Data.define(:drow, :dcol) do
  def turn(delta)
    i = DIRECTIONS_CLOCKWISE.index(self)
    DIRECTIONS_CLOCKWISE[(i + delta) % 4]
  end

  def turn_left = turn(-1)
  def turn_right = turn(+1)
end

NORTH = Direction[-1,0]
SOUTH = Direction[1,0]
EAST = Direction[0,1]
WEST = Direction[0,-1]

DIRECTIONS_CLOCKWISE = [NORTH, EAST, SOUTH, WEST]
