=begin

--- Day 18: Like a GIF For Your Yard ---

After the million lights incident, the fire code has gotten stricter: now, at most ten thousand lights are
allowed. You arrange them in a 100x100 grid.

Never one to let you down, Santa again mails you instructions on the ideal lighting configuration. With so few
lights, he says, you'll have to resort to animation.

Start by setting your lights to the included initial configuration (your puzzle input). A # means "on", and
a . means "off".

Then, animate your grid in steps, where each step decides the next configuration based on the current one. Each
light's next state (either on or off) depends on its current state and the current states of the eight lights
adjacent to it (including diagonals). Lights on the edge of the grid might have fewer than eight neighbors; the
missing ones always count as "off".

For example, in a simplified 6x6 grid, the light marked A has the neighbors numbered 1 through 8, and the light
marked B, which is on an edge, only has the neighbors marked 1 through 5:

1B5...
234...
......
..123.
..8A4.
..765.

The state a light should have next is based on its current state (on or off) plus the number of neighbors that are on:

 - A light which is on stays on when 2 or 3 neighbors are on, and turns off otherwise.
 - A light which is off turns on if exactly 3 neighbors are on, and stays off otherwise.

All of the lights update simultaneously; they all consider the same current state before moving to the next.

Here's a few steps from an example configuration of another 6x6 grid:

Initial state:
.#.#.#
...##.
#....#
..#...
#.#..#
####..

After 1 step:
..##..
..##.#
...##.
......
#.....
#.##..

After 2 steps:
..###.
......
..###.
......
.#....
.#....

After 3 steps:
...#..
......
...#..
..##..
......
......

After 4 steps:
......
......
..##..
..##..
......
......

After 4 steps, this example has four lights on.

In your grid of 100x100 lights, given your initial configuration, how many lights are on after 100 steps?

--- Part Two ---

You flip the instructions over; Santa goes on to point out that this is all just an implementation of Conway's Game
of Life. At least, it was, until you notice that something's wrong with the grid of lights you bought: four lights,
one in each corner, are stuck on and can't be turned off. The example above will actually run like this:

Initial state:
##.#.#
...##.
#....#
..#...
#.#..#
####.#

After 1 step:
#.##.#
####.#
...##.
......
#...#.
#.####

After 2 steps:
#..#.#
#....#
.#.##.
...##.
.#..##
##.###

After 3 steps:
#...##
####.#
..##.#
......
##....
####.#

After 4 steps:
#.####
#....#
...#..
.##...
#.....
#.#..#

After 5 steps:
##.###
.##..#
.##...
.##...
#.#...
##...#

After 5 steps, this example now has 17 lights on.

In your grid of 100x100 lights, given your initial configuration, but with the four corners always in the on state,
how many lights are on after 100 steps?

=end

require_relative 'util'

class LightGrid
  def initialize(input)
    @lights = input.split.map do |line|
      line.chars.map do |char|
        char == '#'
      end
    end
  end

  def size
    @lights.length
  end

  def to_s
    @lights.map do |line|
      line.map do |light|
        light ? '#' : '.'
      end.join
    end.join "\n"
  end

  def on?(row, col)
    (0...size).include?(row) &&
      (0...size).include?(col) &&
      @lights[row][col]
  end

  def num_neighbors_on(row, col)
    (row-1..row+1).sum do |r|
      (col-1..col+1).count do |c|
        [r,c] != [row,col] && on?(r, c)
      end
    end
  end

  def next_on?(row, col)
    n = num_neighbors_on(row, col)
    if on?(row, col)
      n == 2 || n == 3
    else
      n == 3
    end
  end

  def animate(steps = 1)
    steps.times do
      @lights = size.times.map do |row|
        size.times.map do |col|
          next_on?(row, col)
        end
      end
    end
    self
  end

  def num_on
    size.times.sum do |r|
      size.times.count do |c|
        on?(r, c)
      end
    end
  end
end

class BrokenCornersLightGrid < LightGrid
  def initialize(input)
    super
    corner_coords.each { |r,c| @lights[r][c] = true }
  end

  def corner_coords
    [0, size-1].product([0, size-1])
  end

  def next_on?(row, col)
    corner_coords.include?([row,col]) || super
  end
end

if defined? DATA
  input = DATA.read
  grid = LightGrid.new(input)
  puts grid.animate(100)
  puts grid.num_on

  grid = BrokenCornersLightGrid.new(input)
  puts grid.animate(100)
  puts grid.num_on
end

__END__
#...##......#......##.##..#...##......##.#.#.###.#.#..#..#......####..#......###.#.#....#..##..###..
####..#.#...#....#.#####.##.##.#..#.......#....#.##...###.###..#.#.#........#..#.#.##...##..#.####.#
...#..##...#.#.###.#.###..#.##.####.###...#...........#.###..##.#.##.#.###...#.#..###....#.###.#..#.
.#...##...####.#..#.....#..#...#.#.##...#...##..#.#.###....#..###.....##..#.###..###.....##..###...#
..##.#####....##..#.#..##.##..######...#..###.######.....#..##...#.#..##..##..#..#..#..##.#.#.#.#...
.###.###.###...##...##..###..##.###.#.....##..##.#.#########...##..##.#..##.#..##..####..#.#.#.#####
#.#####..###.###.##.##.#...#.#.#.#..#.###...#..##.###.#...####.#..#.#.....###..#..####..#.#.#...##..
....#...##.....#....####.##.#.###..#.#.##..#.#...##.###.###..#.##..#.#.##..##..#.##.###..#.#.###.###
##.##...#.##...#.#..#.#..#...###...###.#..#..#.#####..###.#......#.....###.#####.#.#..#.#.#.##..#.#.
#.#..#.....#.....##.#..##...###..##...##...###.#.###.#..#.#.###...##..##..#.###...#.#######.#...#.#.
#.#.....####.#..#.##...#.##....#####.###.#.....#####....###..#........##..####...#...#.###....#..###
##.#.##..#.#.##.#.....##.#.....###.####.#..######.....####.#.#..##.#.##...#..#.#.....#.####.#.......
#..#..#.#..#.######.##..##.####.....##.#.##.#.######..#.#....#.#...#.#..#..#.#.###.#..#.#.#..#...###
####..####.#.#.###.....#.#.#.##..#.##.##.##.#..##..##.#.##.....#.#..#.####.....###.#..#.####.#.#..##
###.##..##.#.##..#..##...#.#####.##.#....##.####.#.##....#..###.#.#.##...#.....#.#.#.#.#..##.#.#..#.
......#..####...##.##...#.##.##...##..#..##.###..#...#..##...#.#....###.####...#.##.###.#.##.####.##
..#...#####.#.#..#.##....#..#...#..####.....###...##.###....#..#.###...#........#.#.##..#..#.#.....#
#######.#.#.###.###..######.##..#####.##.###.###....####.#..##.##...###.#..############.#.##....##.#
#.#...##.###.#.###..#.#.#.#.#.#..##..####.#..##.....#.##..#.##...##.#..##..#.#.#....##....##.#..#.#.
..#.#.####.....###..#######.#.#.#.#...##.#####.....##...##...##.###..######.###..#...####.#..###.###
.#.##....#.#.##..##.#.##.##..######...#.....#..#.#.#.#.....#.#..##.#.#.......#######....#.......#...
..###.##.##..##....#.###...#.....##..##......###...##..###.##...##.###.#.#.#.###.###.#.#...###..#...
.##.#.#...#...##.#.#...#..#..#.#...##.#.##...##..#....#.#..##.#..#.#..#.#.....#..#.#...#######.#.##.
...####....#.###.#..###..##...##..#.#.#.###...#..##.##.##..##.#...#..#.##.....#.#........#..#.#.####
.....##..###...#....#.#.#.#...###.###...#.#...#.#.####....#..####...###..#..######..##.##..###.#####
#####.##..#....###.###....##.....#.#..#....#.#####.##.#.####.#.##...#..###...###..##...#.###.#####..
###.##..........########.######....####.###.#..##...#.##.####.#.....##..#####..###...#####.....#.#.#
##..#####.##.#.#####.#.##.##..#.##....########.#####.#...#.###.##...#.###.#.#..#....##.#..#...#.#.#.
.##.#....#..#...#..#####..#..##.#......#..#....########...#..#...#.....####.#...##...#.###.#.#..##.#
.##.##.#.##.#.##...#.#.#..##.##.###.#..##..#...###.##.###.#####.#.###..#..###.#...#.###.#...#..#.#.#
.#..#..#.#..#..###..#....###.####.##.#.###.#.##.###.#.##.###.###...###...###.#...####...#.##.##.#.#.
###..##...###...#..##.#..#.#...##....###.##.##..#####....###..#..#....#..###.###.#...#.##...#.#.#..#
#....#.......##.....#.##...#..#.###.#.##..##..#.##..#.###..##.##...#####.#..#####..#####..#####....#
.####.####....###..###.#.##.####.##.#...####.#.###.#.....#...####..#####.###..#.#.###.##.##...##..#.
####..##...##.########...##..###..#..###.##.#.#.#........#.#####.#...#.###.####.#..####..#.#.#....##
###.#..#...###.#..#..#.###...##..###.##.#.#...#..#...####..##....#.#..#..##.#.#...#####.###.#..#.#.#
...##....#.###.#.#..##...##.###.#..#..#......#...#.#..####.#.##..######.####.#...#..#..#..##.#.#.##.
##.####.#...#..#.#.##..##.#.#.###..##...####......#..######.#......#.##.#....##...###.#.#..#......##
#.....#...#######.##.#..#.#...###.#..#.####....#.#.##.#.##...###..#...#.###.##..#.###..#.##...#####.
#####.##...#..#.#.#.......#.##..#####..#####...###..##.#.#..###.#.#####.####..#.#..##...#.##...#.###
.##.#..#######.###.#.####.....##...#.##.#.#..#...##....####......######.#..######.....##########.##.
##...#.#..#.##.###.#.#.#.##.###.##..##.##.##...#.#..###.#######..#.....#####..#....######.#..##..###
.#.#.###.....#..##..#.#..##..#.###...###.#..##...#...#.#####.#.#####..###.#..#...##..#.#..#..####...
.#......##..#.....####.###....##.###.....###.##........#.###.##..#..#.#######.#.######..##..###.....
..##.#.#..#.##...#.###.###...######..#..#.#..#....###.#.#....#..........#...##.##.##.#..##..#.#####.
###.###.#..#.##..##.#..#..##.....##.....#..#######.#..#.#.#.####.###..###.#.#..#.##.##.####.###.####
#.#.#..#....########.#..#..#...##..#.##..#.#..##..####...##.....#.##.#.#...########..#.###.#..#.#.##
.##.....#...#.#...##.##....###...##..#.####...#..#.#..#..#.##..#.###.##.####.##..####.....##.#.....#
....####.#.##.#.##.#..##.#.######.##.####..#...####.#..###.#.#..#..##.#.#.....##.#####.#.####...#.#.
#..#####.#####.....##....######..##....#..#.#.###.#####.....##.##.####.#...##...#.##.#.#####.##.#...
##.####..###.#....#...#.#.#.#.###.#####.#.####..####...####......##..#..#..#.#.##...########....#...
.###.#.#.#.#..####.##.#..######..#.#.###.....#.#......#.#.#.#..####.##...##.#####.#.##..##..#..#.#..
.....###...#...#.####.###.#.#.#.#.....#....#.####.###.##.##.##.#######......#.####......#....##.....
##..#..#.#.##..#...#..##.##.##..###.#....##.##....####.#.##.###....#.##.#.#.##...##.###...#..#..####
...#.#..##..##.#...##.##...#.#......#.#.##..###....####.##...#.#.###.#..#..#.####..##..##..#####.###
.##.##..##########.##...#.##.####.#.#######.##.#.##.##..#...##....########.###..##.##.##.#..##.#.#.#
#####.#....#.##..#.....#......##.##..#.##.###..##.......###..##.#.###.##.###....####.#..#.###..#.#.#
.#...#..#.##....##....#...####....#...#..#...####...########.###.#..##.#.#.##..###..#.#.###.....##.#
##..##.....###......#..###.##.####.##.####.#.#....#..#...#..#.#..#.###.#...#...#..##.##...#..#######
.....##..###..##...#####.#.#.....###.#.#..####...#.#.#..#..####..##.#..###.####.#....##..###....#..#
#.#.##.#....#.#####.#....##...#...##...##....#.#.......#....#..#...###.###.#.####..####....#.##.#.#.
..##...##..###.#.#.##.#..#....#.#.....##.###.#.###.###.....#...#.#..#######.#####..#.###...##......#
#......###..#....#.#..#.###.##.#...##..###.####.#.#....#.##..#.###..##.#..#####..##.###.....#..###..
##.#.##..##.###.#..##.....#.##.....###....##.####.######.#...#..###....#.#...#.##.....###....#..#.#.
.##.#.#.#.##..#.#.#..##..#.###.####....#..###.######..####.#.....###.##..#...###.#..######.##.#.##..
...##.####.#..##.#####.##.#...##..#..#...#.#.#.#####...#....#..###...#..#....#.#.##.#.######.#..####
..#.#.#.#...#.######.#.....#..#.#..###....#.#.########...#....#.#.##..#...##...#.#..#.#.###....##...
#####..#..##..#..##..#..#.#.##.#....#####.####.##.#.###..##..##....#.....#.#####.#...#.#####.##.#.#.
#.#..#####...####.###.###.....####.###.....##...##...#..#..#######.#.##....##..####.....##...#..#..#
#.#.###.#.#..##..#....#.#...#.#.##.##..#.##.....##...#.#..##.......##.#.###..#####.#.##....#.##.....
...#.......#....#.#.####.#.###.###..#....#..##.#..####........#.##..#...#.#...###.#..#.#.#...#...#..
...##.#####.##.#.###.##.##.#.##..##.#.#.#.#.#.##.#..##...##.#.#..#..##.##.#####.#.###...#####..#..#.
#######.#..#..#....##.#.#..####.#..#..###...#..#.......###.#.#.####....#.###...#.#.###.#.#.#.#..###.
..##.##.#.##.###....###.##.#.###.#...#....#.####..###..###.#.#..#...##.#.#.#..##.###..###.#.##...###
######..######..##..##.#.#.##.##.#..##..#.#.#.##..#.#...#...#.#.#..######.#..#.#.######..#......##.#
#.#####.....#.......#########..###.##...#...##.#.#..#...#####...#...#..#.###.#..#.#...###.#.#.#...#.
#....##....###...##.##.#...##.........##.#.#..#.#.##.#.######.#####..#..###.###.#...#.#.##.######...
#.#...###.#.###.##.#.######.#######.###.##..#.#.#...######.##.####.##..#.#.#.#......##..##.........#
..###..##....#.....##...#.#.###.#.#.....##.#...###.####.#...#...##..##.#.#.####..###...######....#.#
..###.#.##.####.#..#.##....##..#####....#..##.##.#..#######...#.####...##.#.#.##.........#....#....#
.##.#...#.####..#.#...#.##..######.##..##.#.###.##..###.###....##..#.##.##..##.#...###.##.##.###....
#...###.###.#..#....#.......#..#.....###..#.###.##.##....#.####.#.####.##..##..#..#.....#....##.#.#.
.##.#..#..#.##.......#.####.#######.....#.##.##.#.....#.#..#....######.#..###.##.##.....#.####..##.#
###..#.###.#..####.....##....#..####....#.##.##..#...######.#########...#.#....##...###.#..#.##...#.
#..###..##..#.#.##.###.#.#.##...###.#...##.##..#.###....###..#.#...#.###..######.#..#.###..#..#..#.#
.#........##.#.###..###.#.#.##.....##.##.#.#...##..#.##....###..#.#.#.#.##....#.##..#.#...###...#...
####.####..#....#.#.#..#..##.......##.####...###.##..#.#.##.#..##..######.......##.#.##..#...#.....#
..#..#..###..##.##..######.#..###..###.#.##..##.#..#####.#.#.#.##..#.##..##.##......####.#..........
...##.##..###.#...###....#.#.#.#.....#.##.....##...#...#......####...##.##....##.#..#.####.#..###.#.
..#.....####.#.###.#####..#..###..#..#.#...#####...###.###....#.###..#...#..#..#.#..#.##..##.#.#....
..##.#####...###.###.........#....##.####.##..#.#..#.#...#...##.##.##..#.#.##.########......#####...
...###.#.#..#...#.###.###.......##.###.#..#.##########...#..#.#.#.##.#.###...######..#.#...###.##...
.#.#.#######.#..##.##..##...#...####...#..#####.#..##...###.#.#...#.##...#......#..##.####..#.....##
.##.##.#.#......#######..###.....##.#.##..###......#....####...#.###.#.##.#........#..#....##.....##
#...#.###.#.##...##.####....#...#.###..#.#.....#.#....#.#.#.##...#.#..#####.#.#..#..#..#....#...####
.....##...###......#####..##.##.##...##.#.#####..##...#.#.#.#.###...###.##.####..#.#..#.#..#.####.##
#..#..##.#.##.#.##.#.#.#..###....###.##.#.##.#...#.#..#...#....###.#..#.#.######.#...####..#..##.#.#
#..#.#..#...###.#..##.#...#...##.#......#...#..#..####..##.....#.###...#.#..#.#....#.#####.##.###...
###....#.#..#.#..###..#.##......#...#..#..##.#..###..##..#..#.####..#...########..##.#.##.#.#.#...#.
.#.#.##.##.###..#...#.#....#..#.##..#.#.#.#.##.##.#####...#........####..###..####.#####..#.##.#.##.
