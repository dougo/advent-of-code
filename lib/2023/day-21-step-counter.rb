=begin

--- Day 21: Step Counter ---

While you wait, one of the Elves that works with the gardener heard how good you are at solving problems and would
like your help. He needs to get his steps in for the day, and so he'd like to know which garden plots he can reach
with exactly his remaining 64 steps.

He gives you an up-to-date map (your puzzle input) of his starting position (S), garden plots (.), and rocks
(#). For example:

...........
.....###.#.
.###.##..#.
..#.#...#..
....#.#....
.##..S####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........

The Elf starts at the starting position (S) which also counts as a garden plot. Then, he can take one step north,
south, east, or west, but only onto tiles that are garden plots. This would allow him to reach any of the tiles
marked O:

...........
.....###.#.
.###.##..#.
..#.#...#..
....#O#....
.##.OS####.
.##..#...#.
.......##..
.##.#.####.
.##..##.##.
...........

Then, he takes a second step. Since at this point he could be at either tile marked O, his second step would allow
him to reach any garden plot that is one step north, south, east, or west of any tile that he could have reached
after the first step:

...........
.....###.#.
.###.##..#.
..#.#O..#..
....#.#....
.##O.O####.
.##.O#...#.
.......##..
.##.#.####.
.##..##.##.
...........

After two steps, he could be at any of the tiles marked O above, including the starting position (either by going
north-then-south or by going west-then-east).

A single third step leads to even more possibilities:

...........
.....###.#.
.###.##..#.
..#.#.O.#..
...O#O#....
.##.OS####.
.##O.#...#.
....O..##..
.##.#.####.
.##..##.##.
...........

He will continue like this until his steps for the day have been exhausted. After a total of 6 steps, he could
reach any of the garden plots marked O:

...........
.....###.#.
.###.##.O#.
.O#O#O.O#..
O.O.#.#.O..
.##O.O####.
.##.O#O..#.
.O.O.O.##..
.##.#.####.
.##O.##.##.
...........

In this example, if the Elf's goal was to get exactly 6 more steps today, he could use them to reach any of 16
garden plots.

However, the Elf actually needs to get 64 steps today, and the map he's handed you is much larger than the example
map.

Starting from the garden plot marked S on your map, how many garden plots could the Elf reach in exactly 64 steps?

--- Part Two ---

The Elf seems confused by your answer until he realizes his mistake: he was reading from a list of his favorite
numbers that are both perfect squares and perfect cubes, not his step counter.

The actual number of steps he needs to get today is exactly 26501365.

He also points out that the garden plots and rocks are set up so that the map repeats infinitely in every
direction.

So, if you were to look one additional map-width or map-height out from the edge of the example map above, you
would find that it keeps repeating:

.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##...####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................
.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##..S####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................
.................................
.....###.#......###.#......###.#.
.###.##..#..###.##..#..###.##..#.
..#.#...#....#.#...#....#.#...#..
....#.#........#.#........#.#....
.##...####..##...####..##...####.
.##..#...#..##..#...#..##..#...#.
.......##.........##.........##..
.##.#.####..##.#.####..##.#.####.
.##..##.##..##..##.##..##..##.##.
.................................

This is just a tiny three-map-by-three-map slice of the inexplicably-infinite farm layout; garden plots and rocks
repeat as far as you can see. The Elf still starts on the one middle tile marked S, though - every other repeated S
is replaced with a normal garden plot (.).

Here are the number of reachable garden plots in this new infinite version of the example map for different numbers
of steps:

In exactly 6 steps, he can still reach 16 garden plots.
In exactly 10 steps, he can reach any of 50 garden plots.
In exactly 50 steps, he can reach 1594 garden plots.
In exactly 100 steps, he can reach 6536 garden plots.
In exactly 500 steps, he can reach 167004 garden plots.
In exactly 1000 steps, he can reach 668697 garden plots.
In exactly 5000 steps, he can reach 16733044 garden plots.

However, the step count the Elf needs is much larger! Starting from the garden plot marked S on your infinite map,
how many garden plots could the Elf reach in exactly 26501365 steps?

=end

require_relative '../util'

class StepCounter
  def self.parse(text)
    lines = text.lines(chomp: true).map(&:chars)
    new(Grid.new(lines))
  end

  def initialize(grid)
    @grid = grid
    @start = grid.each_position.find { grid[_1] == 'S' }
  end
  attr :grid, :start

  # Can pos be reached in an even number of steps?
  def even?(pos)
    ((pos.row - start.row) + (pos.col - start.col)).even?
  end      

  def plot_at(pos, infinite: false)
    grid[infinite ? Position[pos.row % grid.height, pos.col % grid.width] : pos]
  end

  def empty?(pos, ...) = plot_at(pos, ...).in?(['.', 'S'])

  def empty_neighbors(pos, ...) = pos.neighbors.filter { empty?(_1, ...) }

  def plots_in_steps(max_steps, infinite: false)
    visited = Set[start]
    frontier = [start]
    steps_map = [frontier]
    1.upto(max_steps) do |i|
      break if frontier.empty?
      frontier = frontier.flat_map { empty_neighbors(_1, infinite:) }.to_set - visited
      visited.merge(frontier)
      steps_map << frontier
      # pp [i, frontier.length, visited.length] if infinite
    end
    steps_map
  end

  def num_plots_in_steps(steps, ...)
    plots_in_steps(steps, ...).each_slice(2).sum { |even, odd| (steps.even? ? even : odd).length }
  end

  # The number of steps to reach every reachable plot.
  def max_steps
    plots_in_steps(Float::INFINITY).length - 1
  end
end

if defined? DATA
  input = DATA.read
  obj = StepCounter.parse(input)
  puts obj.num_plots_in_steps(64)
  puts obj.max_steps
  puts obj.num_plots_in_steps(500)
  puts obj.num_plots_in_steps(501)
  puts obj.num_plots_in_steps(500, infinite: true)
end

__END__
...................................................................................................................................
....#...#.......................#.#......###..#.............#................#.....#.....#.#...#.........#.#..........#......#.....
...#.##.#...#.....................#.......#.......#....#...................#....#...........#.#...........#....#...#...............
.#........#.#................#.....#.....#.........#.......................#..#...#........#..#..........##............#...........
.....#.#.....#.....#..........#........#.........#...#..........................#....#.#......#....#.#####.................#.#.....
...........................#...........#...#..#...#...............#.......#......#.#......#.......#.......#.........#.........#....
......#...#.....##.......................#.....................#..............#..#...##...#....#....##....##....#..#...............
..................#...........#.................................#..#.......................#....#.....#................#...........
.#....##......#.............#.#.....#...#..#...#.....#.......#.....#.#..........#..##..........#.........#.........................
...........#.......#.....#................#.....#..............................#.#....#...............#..........................#.
............#.#..............#.......#...................................................#......##....#.......#...##...............
...................#.#......#.....................#........##.#....#...#............#...................#.....##.....#..#.#..#...#.
..........#......#...#...#..#.................#..............#.....................#.........#.#........#.......#.#..............#.
......#.......#...#.#............#.....#.#...................#...........##.......................#...#...##......#..#......#......
.#.............#.....#......#.....#.........#..............##..................................#..#..#.#........#.....#............
......#...............#......#............................#.............##..#.........##.........#.#......#......#..............#..
.........#..............#..................................#.................#..........##.......#........#........##............#.
.....#..........#.....#.#..................##..........#....#.....#...#...#..#........#.............##.......#.....#........##.##..
......#........#.....................#................#......................#...........#...#......#...##.........................
..............#................#..#...................#...###...............................#.#..##........##......##...#.....#....
....#...............##.....#.#........#..............#..#.......#..#..#........#............#..##....#......#.....###..............
.#......................#..#...#....#...........#...#...............#........#............#...#.##....#................##....#...#.
......#.......#.#...#......##.....................#...............#......#.....................##.....#.#.....##.................#.
......##................#....#...#...#.............#..................#.........#...............#...........##.................#...
....#.....#...#.#....#....#.......#.#.........#...###........#.........#.....................#.....#.##...#..##......#...#.........
.................#....#...#....#.#......................#...........#.....#.....#.#.##........#..........#......#..#....#..........
....#...........#.......#....................#.#...#.........#.............#..#..................##............#.#.................
...................#.#.......#...##............#....#...........#.......#........................#...........#.##....##....##......
......#..#.#...#..............#...............................#.....#.#.............#..#............#........#..............#.#....
..#....#...........#...##..##..#........#..#.....#....#...#...#...#....#.#............................#.#.#........................
......#................#.#................#..#....##........#........#....#...#..#.#......#..........##....#...#......#.#.#...#..#.
...#.#..##..#......#......................#................#....................#............................##...#......#..#......
....#...#.##...##.......#................#.#..#........#.#.............#............##.#..........................##......##.......
...#.........###.#.....#............#.........#................#..............#............................#......#.....#..#.......
...###....#.........................#..#...#............................#.....##..#..........#...........#.....#................#..
.............##.....#...............#..........#.....#.............#..#...#..#........#.#.#.............#............#...........#.
.......#..........#..............#.......#..#........#.#...............#................#....#...............#.....................
.............#..#.....................##.....#.#...............................#..#..#..#....#...##............#..#......#.........
................#...#.#.............#............#...........................#...........##...#..#..........#.......#..#........#..
.........#.#.........#...........#.........#..........#...........#.............#..........#..................#...#....#....#..#...
...#.#.....#...#...............#..#......#.......##........#..#......#..#.....#..........#...#.#.............#...#....#.....#......
..#...#..##.....#............#.#......#...#................................#.##.............###....#................##....#......#.
...................................#.#...#.......#.....##....#.#......#..#.............#...........#..#........#.................#.
.......#..................#..#................#.........................#.................#..........#..#.....................#....
..........#...#.##..................#......##..##......#......#......#..##.....#..............#....#.............#...#..##.#...#...
................#.........................#.......#...............#.......#..#....##...#......#....#................#............#.
..#....#..##.#...........#.........##..#..#..#.................##......#...##..................##....#...............#.#..##.......
......#......#...........#....#...#....#.#......................#...........#................#.........#.#..........#.#............
.....#....#..#.......##....................#................#.......#...........#.......#..............#..................#........
..#........#........#.#.....##........#..#.....#.....#......#......#.#............##....#..............#..............#...#........
..#.##........................#..##.#.........#.....#...#............#..............#...#.........#...........#............##......
...#........................#.#....##.#.......#.#.............#....#...#......#.....#.....#..#......#...##...............#.........
......#...........#.................#......#.#......#.......##.#.....#.....#..............#...................#..............#.....
.......#..............#..........#..........#...........#...#........................#..#....#............................#....#...
................#..#.......#....#..##............####....#..#...#................#..............#................................#.
...#..#............#..#........#.......#......#..##...............#..#.#...#......#.........#.................#.#...........#.#....
..#...............#...#..........................#.#.......#..#..........#...#.......#..#....#.#..............................#..#.
...#................................#...#.....#...#........#.......#..#..#..............#...#.....#.......#........................
............##.............#.......#...........#...##......#......#.................#.......###...........#......#...............#.
.......................#...###.........#.....#.................#....##..#............#...........##....#.........#.#..##...........
...........##.....................#....#..#....................#.....................#..........#.....##........#................#.
........#........#.....##........##.........##..#.#..................##..........##...#...##..............#......#.................
...................#.........#.##..#..#.#..#...........##................#.......#......#...#.#........#.#..#......................
.................#..........##.............#.....#.......##..#..#.......##..##...............#..............#......#.##............
............#....#.............##...#.....#..................###..#..#......#............#............##..............#....#.......
.................................................................S.................................................................
............#......#....#........#..#..#.#..................#..#......#................#...........#.#..#....#......#..#.....#.....
................#.......................#...##.........#...............#.#...................##.........#....#..#...........#......
...........#..##..#...........#........##...........#..##..#..#..........#......#..........#....#..#........#.........##...........
.........##..#...#.............#....#...........#...#...#......#..#...............#........#..............#.#....#.................
.#............................#..............#....##.....#..#..#............#.#....#..#......#.....#........#.....#................
...................#...#...........#............#.....##........#....#....#..#....#.........#.#....#.#.....##..#..#....#...........
................#.#...#....#.#....##..#..##...#.......#.#............#.........................###.#.................##............
.#.#.........................#.....................#.......................#.#...#..##...#..#.#.......#...............#.......#..#.
..............#...###...........#....#..#.................#..#......#.#........#.#...#...#..#..#...#.#..#.....................#.#..
.....................................##...............#.#.......#.......#..........#......#.........#..#............#..............
......................#..#.#.#...........#.##.....#...............#...#.........#.....##............##......................#....#.
...................#....#..#.#...#...#.....#.........#..#.......#...........#..#......................#.......#...........#........
.....................#...#.....#.#......#....##..##.##.........#..........#...........###......#......#.......#...............#....
..#.....................#..............#.#..#............#.....#.........#.#..............#................................#.......
.#........#...........##...........................#........#......##............#......#......#......#............................
...........#...................#...##......#...........#...................#...................#.#......#.............#..#...#.....
..........#..........##........##..#.#....#.....#...........##.......#...........#.......##.#........#...#............#..........#.
.........#...........................#...#.##...........#.............##....#...#...#.............#.....#...#.........#............
..#.....#...........................#....#.................#..#....................##..#.##.##....#......#..................#......
.....##...................#......#.#..#.............#........#......#..#.........................#....................#....#...#...
.#...................................#....#........#...#.#...#...........#.#.......#..#..#.......##.#...................#....#.#.#.
.#......#....#....#........................#....................#...#..#...#..#...........#......#..#..............................
..........#.......#..........#.........##...##.....#.......#....#..........#..#......#..................................##.........
...#...........#...............#.#....##......#.....................#....#..........##..#..##....##.#.........#......#.......#.....
.#.................#...........#......#...#........#.........#.##..............#.......#...#.#...#...#..........#..#.#.............
.....#..#...#...#...................#...#..#..#.......#..#................#............#......#...................##..#..........#.
......#.......#...#..............#.##.....#..#........#....#..........#..###...................................#............#......
..#..........#...#..##..#...........##.........##....#..#...#..........#.##.......#.......#..#..#............#.#...#.......##..#...
..#..#....#..##........##...........#.#..................#......#.#.#........#..........#.................................#..#.....
.................#...........................#..#....................#..#.#.#..#....#....#..............#....###.....#...#..##.#...
......#.....#.........#.......................##.....#.......#.#..##....#.....#....#...##...#..#..........#....#..#................
..........#........##...........................#.#..........#................#.....#.#...##.......................#.......#..#....
.........#.....#...........#...........................................................................#.....#...............#.....
.................#.....#..................#...#....#.#............#..##..........#......#.##.............###......#..........#.....
.#...................................................#..#..#.#........#...............#....................#.............#..#......
..#..#......#..#........#..#..............##...........#.#........#.........#..#....................................#.....#........
.#.....#..#.#..##....#...#......................#..........###.#..##.......#.........................#....#........#..#............
..#.......#.#.......#........#.#.............#..........#.........#...#.....................................#........#.##.......#..
...#......#.#......##.##......##.#...........##....#.....#......................#...............#.....##.............#..........#..
.#.#....#...................................##.................#.............##.#................#...#.#...#.............#.....###.
..#..........#.##.###....#...#.......#..............#.......#.................#.#....#..........#.#...#...#..#........#............
.......##.........#....#....##..##............##.........#...........#...##.#.....##..........#.........#............#.#....#.##...
....#...###...........#......#.................#.....#.#.................#.................#......#.............................#..
...#..#...................#..#....#...#.............#.......#.#.........###...#...................#....##..#...........#......#....
.#...............#.............#..##............................#..........##.................#.#.#.##....#.......#.#...#..#.......
..#...........#.....................#..#...........#..#.##..#......####.........#..............................##........###.##.#..
.......#.....#..........#.#.........................#...........#.....#...#....#..............#..........##.#................#.....
.#.....#....#...#....#..........#....................#................#....#...........#....#.....................##...#....#....#.
................##...#....#........#..##.............#............##.#....##............#........#.##............#.#.........#.....
......#.#.#.#....#........................#..................#.#........................#........#.#....................#.....#.#..
......#..#.........#........#....#...#...#...#...............##.......#.#.............................................##...#....#..
......#.#......................#....#..#....................#.......#................#..#..#.#..#...............#.........##.#.....
............#.....................###.......................##.....#.....#........#...#........#.........#..#........#.........#.#.
....#......#..#.................#........#..#...#.........#.....#.#.................#.............#..#.....#........#....#.........
.#..#......#..#.....................#.....#......#..............................#..#..................#..#..##...........#.........
...#.............#...........#...................#.#........#.....#............#............................#..#...................
.....#....#.........#..#.#..............#.#..#.##....#.......##..........................#....#...........#...............###......
......#................#..#....................#.....#........................#.#....#.......#................#.............#...#..
..........#...........#.........#.................#.........................#........#..#.............#......#..........#..#.......
.....#...#...................#.....#.........##..#.....................................#.....#.#....#........#...#..#....#.........
..#.#.......#...##..#........#..##...##.#...#...........#.........................#.....#........#..................#....#.....#.#.
.#.........................#.............#.......................................#..........##....#..#####.#.#.................#...
.#.#...........#.....#.##.....#...............#....#.....#.#.................#..#.....#...#...........#......#...#............#..#.
...#...........#..#............#.......#.#.........#..##................#.#.......#............#.................#.....##..........
...................................................................................................................................
