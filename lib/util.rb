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

class Grid
  def self.parse(text) = new(text.lines(chomp: true))
  def initialize(rows) = @rows = rows
  attr :rows

  def height = rows.length
  def width = rows.first.length

  def row_range = 0...height
  def col_range = 0...width

  def include?(pos) = pos.row.in?(row_range) && pos.col.in?(col_range)

  def [](pos)
    rows[pos.row][pos.col] if include?(pos)
  end

  def []=(pos, val)
    rows[pos.row][pos.col] = val if include?(pos)
  end

  def each_position(&block)
    enum = Enumerator.new do |y|
      row_range.each { |row| col_range.each { |col| y << Position[row,col] } }
      self
    end
    block ? enum.each(&block) : enum
  end

  def ==(grid) = rows == grid.rows
  def eql?(grid) = rows.eql?(grid.rows)
  def hash = rows.hash

  def dup = self.class.new(rows.map(&:dup))
end
