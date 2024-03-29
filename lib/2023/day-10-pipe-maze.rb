=begin

--- Day 10: Pipe Maze ---

Scanning the area, you discover that the entire field you're standing on is densely packed with pipes; it was hard
to tell at first because they're the same metallic silver color as the "ground". You make a quick sketch of all of
the surface pipes you can see (your puzzle input).

The pipes are arranged in a two-dimensional grid of tiles:

| is a vertical pipe connecting north and south.
- is a horizontal pipe connecting east and west.
L is a 90-degree bend connecting north and east.
J is a 90-degree bend connecting north and west.
7 is a 90-degree bend connecting south and west.
F is a 90-degree bend connecting south and east.
. is ground; there is no pipe in this tile.
S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the
pipe has.

Based on the acoustics of the animal's scurrying, you're confident the pipe that contains the animal is one large, continuous loop.

For example, here is a square loop of pipe:

.....
.F-7.
.|.|.
.L-J.
.....

If the animal had entered this loop in the northwest corner, the sketch would instead look like this:

.....
.S-7.
.|.|.
.L-J.
.....

In the above diagram, the S tile is still a 90-degree F bend: you can tell because of how the adjacent pipes
connect to it.

Unfortunately, there are also many pipes that aren't connected to the loop! This sketch shows the same loop as
above:

-L|F7
7S-7|
L|7||
-L-J|
L|-JF

In the above diagram, you can still figure out which pipes form the main loop: they're the ones connected to S,
pipes those pipes connect to, pipes those pipes connect to, and so on. Every pipe in the main loop connects to its
two neighbors (including S, which will have exactly two pipes connecting to it, and which is assumed to connect
back to those two pipes).

Here is a sketch that contains a slightly more complex main loop:

..F7.
.FJ|.
SJ.L7
|F--J
LJ...

Here's the same example sketch with the extra, non-main-loop pipe tiles also shown:

7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ

If you want to get out ahead of the animal, you should find the tile in the loop that is farthest from the starting
position. Because the animal is in the pipe, it doesn't make sense to measure this by direct distance. Instead, you
need to find the tile that would take the longest number of steps along the loop to reach from the starting point -
regardless of which way around the loop the animal went.

In the first example with the square loop:

.....
.S-7.
.|.|.
.L-J.
.....

You can count the distance each tile in the loop is from the starting point like this:

.....
.012.
.1.3.
.234.
.....

In this example, the farthest point from the start is 4 steps away.

Here's the more complex loop again:

..F7.
.FJ|.
SJ.L7
|F--J
LJ...

Here are the distances for each tile on that loop:

..45.
.236.
01.78
14567
23...

Find the single giant loop starting at S. How many steps along the loop does it take to get from the starting
position to the point farthest from the starting position?

--- Part Two ---

You quickly reach the farthest point of the loop, but the animal never emerges. Maybe its nest is within the area
enclosed by the loop?

To determine whether it's even worth taking the time to search for such a nest, you should calculate how many tiles
are contained within the loop. For example:

...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|..|.|..|.
.L--J.L--J.
...........

The above loop encloses merely four tiles - the two pairs of . in the southwest and southeast (marked I below). The
middle . tiles (marked O below) are not in the loop. Here is the same loop again with those regions marked:

...........
.S-------7.
.|F-----7|.
.||OOOOO||.
.||OOOOO||.
.|L-7OF-J|.
.|II|O|II|.
.L--JOL--J.
.....O.....

In fact, there doesn't even need to be a full tile path to the outside for tiles to count as outside the loop -
squeezing between pipes is also allowed! Here, I is still within the loop and O is still outside the loop:

..........
.S------7.
.|F----7|.
.||OOOO||.
.||OOOO||.
.|L-7F-J|.
.|II||II|.
.L--JL--J.
..........

In both of the above examples, 4 tiles are enclosed by the loop.

Here's a larger example:

.F----7F7F7F7F-7....
.|F--7||||||||FJ....
.||.FJ||||||||L7....
FJL7L7LJLJ||LJ.L-7..
L--J.L7...LJS7F-7L7.
....F-J..F7FJ|L7L7L7
....L7.F7||L7|.L7L7|
.....|FJLJ|FJ|F7|.LJ
....FJL-7.||.||||...
....L---J.LJ.LJLJ...

The above sketch has many random bits of ground, some of which are in the loop (I) and some of which are outside it
(O):

OF----7F7F7F7F-7OOOO
O|F--7||||||||FJOOOO
O||OFJ||||||||L7OOOO
FJL7L7LJLJ||LJIL-7OO
L--JOL7IIILJS7F-7L7O
OOOOF-JIIF7FJ|L7L7L7
OOOOL7IF7||L7|IL7L7|
OOOOO|FJLJ|FJ|F7|OLJ
OOOOFJL-7O||O||||OOO
OOOOL---JOLJOLJLJOOO

In this larger example, 8 tiles are enclosed by the loop.

Any tile that isn't part of the main loop can count as being enclosed by the loop. Here's another example with many
bits of junk pipe lying around that aren't connected to the main loop at all:

FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L

Here are just the tiles that are enclosed by the loop marked with I:

FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJIF7FJ-
L---JF-JLJIIIIFJLJJ7
|F|F-JF---7IIIL7L|7|
|FFJF7L7F-JF7IIL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L

In this last example, 10 tiles are enclosed by the loop.

Figure out whether you have time to search for the nest by calculating the area within the loop. How many tiles are
enclosed by the loop?

=end

class PipeMaze
  def initialize(text)
    @sketch = text.lines
  end

  def height = @sketch.length
  def width = @sketch.first.length

  def each_position
    (0...height).each do |row|
      (0...width).each do |col|
        yield Position[row, col]
      end
    end
  end

  def pipe_at(pos)
    pos => row: row, col: col
    if (0...height).include?(row) && (0...width).include?(col)
      @sketch[row][col]
    end
  end

  Position = Data.define(:row, :col) do
    def neighbors = [north, east, south, west]
    def north = with(row: row - 1)
    def east  = with(col: col + 1)
    def south = with(row: row + 1)
    def west  = with(col: col - 1)

    def connected_neighbors(pipe)
      case pipe
      when '|' then [north, south]
      when '-' then [west, east]
      when 'L' then [north, east]
      when 'J' then [north, west]
      when '7' then [west, south]
      when 'F' then [east, south]
      else []
      end
    end
  end

  def start_position
    each_position do |pos|
      return pos if pipe_at(pos) == 'S'
    end
  end

  def connected_neighbors(pos)
    pos.connected_neighbors(pipe_at(pos))
  end

  def positions_connected_to_start
    last = start = start_position
    positions = [start]
    pos = start.neighbors.find { connected_neighbors(_1).include? start }
    until pos == start
      positions << pos
      pos, last = connected_neighbors(pos).find { _1 != last }, pos
    end
    positions
  end

  def farthest_distance_by_pipes
    positions_connected_to_start.length / 2
  end

  def area_enclosed_by_pipes
    pipe_positions = positions_connected_to_start.to_set
    area, inside, last_bend = 0, false, nil
    each_position do |pos|
      if pipe_positions.include?(pos)
        case pipe_at(pos)
        when '|' then inside = !inside
        when 'F' then last_bend = 'F'
        when 'J' then inside = !inside if last_bend == 'F'
        when 'L' then last_bend = 'L'
        when '7' then inside = !inside if last_bend == 'L'
        end
      elsif inside
        area += 1
      end
    end
    area
  end
end

if defined? DATA
  maze = PipeMaze.new(DATA.read)
  puts maze.farthest_distance_by_pipes
  puts maze.area_enclosed_by_pipes
end

__END__
L77FF.FJF|FL-7F7FF-F7F7FL.|.F-77.F--|.J7.FFLL--|7-7.7-L77F7-7.F-7F7-FF7F|77.|-JF7-FFF.L-7FFF7---|F7.|.FLF-JF-|-7---|F77FF-F-77FL77|-77.|-J.F
L7F-|7LLFJFL-FJ7L|.FL.LJJF7.|.|L-FJFJJ7L.777L-7.F7F-|7.F-7L7-F7LF-7.|L-JJF7-J-L7|F-JJFJLJ-L||.|LL|JF7-7FJ-FJ.J.J.|FLLJ7-F-L-L|7LJ-7-JL7F7|FJ
FF7|.-7F|J-|.|LFJJL-J7|.7FJ7L-77JLJJJ7F77JLJ77|-F--FJ.-JLL-J.LJJ.L|--7.J-JJ.|-F----LL-7FJJF||F--7F-7.F-7.L7-|.-LL-77JFJ.J7F-JL|.||L.FF||JLJ|
-JL-|--JF-7FFJFJ7FL7F-J7.L7L77L-7|JLF7-J|.7||J|L7.LF-J|.FJ.--7L|F|J|L|.|J.LF7--7J|F.|FF-7FF|||F-J|FJFJJFFJL-FJLF-J|7F7J..FF.|..|-LL---777J|7
||.||L|7||-JJFF|.|.F-J.7-FLJL77-L--.|.|LJFL-L|FFL||L|F-7L77.FJ7|F7L-.F-7.|F7L|.-JFFF7-|FJF7||||7.||F7L-.L-7.|..|7.|L7J..L-7L-77|.|J.FLLJ77|.
FF7-7|F7LJ7|F-LF-7.LFLL|-|L|LLL.LL-FJ-J-LL-7-LL-|J7FJL7|JFJ|-JFL||LJ--.FJ7LF-77LF7FJL7||.|LJ|||-FJLJ|J-L7|LJJJ-L-7LLJ|FL7|J.L||F-..7JJ|7F-J-
|||LJ---.---77.JF|-.|LFF7|F|..|7.|JJ|.||.FF-7|LF-F7F7L|J-|..|7FJJ-7-7JF77|.L7|F-J|L-7LJL7L7FJ|L7|F--J.FF7-7J..JJF|J|.JJ7-|-F7J7J7F7L|.FFL--|
L-L-7.7F-.7JLL-|7|.J.--.LLFJ--7--F.L7J777|.L|J.||.FJ|.L-JFF-FJ.F|L|-F-|L7L7L||L-7|F7L-7FJFJL7L7LJL-7LFL7.F77-|LLFFF7-LJF---FJJL|7||-L7J|||FF
F-JF--JLJFJ7FL.|LF7-7.L7-|LJJFJ.|.J.|L-|-F--|L-7JF7.F|J7-L|7L|7-J|F7F7|FJF-7||F7|LJ|F7|L7L-7|7L7F--J-|J.F||F-7F-77LJ-J7J|LFJL-7FF|-7.F.7JFJ7
||.|JL7F-7|||.L-77.7.--|-|FL|7LF-7|L--7|.|7...|JFF7.J|LF.F|.7.77LF|||||L7L7LJLJLJF-J|||FJFFJL7L||F7F77-F-J||FJ|FJ--L7-|7F7.L.LFJ.FJF7JLL7|7J
F-F..FL--L7LJ..LJJ7.F|-J..L7.JL7.F7JLLLF-JF-7-7-F||-|F77F-77J-|J.FJLJLJFJ|L-----7|F7|LJL7FJF7L-JLJLJL7.L-7||L-J|JJ.FLFJ-J-7-FF7..|LJ|.FF--77
|.L77F7J7|JF|--||LFF-J.7-F7F|F-J7LFJFF|JJ7L7|F7F7|L7FJ|FJFJ|F7-7-L----7L-7LF----JLJ|L-7FJ|FJL--------J7F-JLJF7FJJF7.-JJF|J7FF-JL|-FJ--LFL-LJ
77.LJF|-7-..||L---.|J..-7-L.LJ7.L7L7J-F7.F7|||||||FJL7||FJF7F7JLL|F--7|F-JL|F-----7|F7|L-JL7F7F7F--7F|FL-7F-JLJ..FL|J||L.||F|..FJFLJJ|7F.LL-
JJ7FF-JLJ.F7-J7LL|-L7.|.||FF-LF7JF7LFFJL7|||||LJ||||FJ|||||LJ||LF7L-7LJL7LFLJFF7F-J|||L7F--J|||LJF-JF-7-FJL7FF77|7LF-FJ|FF--77-J.|J|F-JL|7J|
LL7-|J77FLF.L-|FL7-|7-|7FF-7.F77F|L7-L7FJ|||LJF7||L7|FJ|L-JF-J-7||7||F-7L-7|F7|||F7LJL-JL7F7||L-7L7FJFJFJF7L7||-|J-JLJLF-|7-|J|JLJF7-J|FLF.|
F--JLF-77|L7FF|F7|.L7L-JF|FJF|L-7L7|F7||.||L-7|LJ|FJ||7L-7FJ7||FJL7FJ|FJF7L7||||LJL7F--7FJ|LJL7FJFJ|FJFJFJL7LJL7JL7|J|L|-FF-L7L7JFL||F-7JF-J
JL|7LL7F-J-|-LF-JF77JF7F7|L-7L-7|FJLJLJ|FJ|F7|L-7||FJL-7FJ|F7F7|F-JL-JL-JL7LJLJL7F7LJ7FJL7|F--J|FJFJ|FJFJ7LL---J77F|.F.L7.L7.L7|.|J|LJL|.|L7
J.|JL|7.|.F-.|.|7L7JF.F|||F-JF-J|L----7LJFJ||L7FJ||L--7||FJ|||LJ|FFF--77F7L----7||L7F7L-7|||F7FJL7L7LJFJF7F7F-7F7F7JFJ-LL--|-7FF7F7|LF-7-J-|
.7JL.7-7F.L7F|JJ7-|FLF7|||L7JL-7L7F-7FJF-JFJL7|L7|L--7|LJL7||L-7|F7L-7L7||F-7F-J|L7||L-7|LJ|||L7FJ|L7FJ|||||L7||||L77..L|JFL-LJL||F----J7-||
.|7.-J|FJ.LLF.|-FF-7L|||LJFJF-7|FJL7LJFJF7L7FJL7LJF--J|F--J||.FJLJL7LL7|||L7||F7L-J||F7|L7FJ||7||-F-J|F-J|||J|LJLJFJ7.L-7|L.J|..JFF-7-7J|-FJ
F-|FJ.7JF-F-L-F7-L7|FJ|L-7L7L7||L-7L-7|7|L7|L7|L-7L-7FJL--7|L7L7F--JF7||||FJ|LJL--7|LJ||J|L-JL7|L-JF7LJF-J||FJF---JF77FFF|LJ-FLF.JL-F.|J|F.|
-J.JJ.|.|..FF--||L|LJFJ|L|FJFJ|L7FJF-JL-JFJ|FJF7FJF-JL7F--JL7|FJL7F7|||LJ|L7L7F7F-JL7FJ|FJF--7|L---J|F-JF7||L7L---7||F-77L7JFJ|L.|FLL-|77J.|
|.|.L7J---F|L-LL|JL-7|7FFJL7L7|J|L7L-7F--JFJ|FJ|L7L7F7|L-7F7||L-7|||||L-7|-|FJ||L-7FJL7||FJF7LJF7F77||F7|LJ|-|F---J|||FJJ.|.L-77FL|.|.L|.F7J
-F7-.J.|.F77LF7|FF7FJL-7L-7|FJL7L7L-7||F-7L7|L7L-JFJ|||F-J|||||FJ||||L7FJL7|L-J|F7|L7FJ|||J||F7||||FJLJLJF-JFJL7F7-||||F-7J7-|.FJJLLJ7JL-L77
|L|.7LL7F||F7||F7||L--7L-7|||F-J-L-7||||FJF|L7L--7L7|||L7FJLJL7L7|||L7|L-7|L--7||||FJL7LJ|FJLJ||||LJF-7F7|F7|F-J|L-JLJLJFJ-|-L-L.J-7FJFLF-J|
FJ..L7FL-|||LJLJ|||7F7L-7LJ||L7|F7FJ||||L7FJFJF7|L7LJ||FJL7F--J-||||FJ|F7||JF-JLJ|||F7L-7LJF--J||L-7L7LJLJ|||L-7|F------JJ7J..|L77F7-7FJJL7J
L--77-L7|||L-7F-J||FJ|F7L-7||FJFJ|L7LJ||FJ|FJ7||F7L7FJ|L-7||F7JFJ||LJFJ|||L7L---7||LJ|F7L7FJF7FJ|F7|FJF7F7|||F-J|L------7.---.--L-L7F||F77L7
||FL7FF7-|L--J|7|||L7LJL-7|||L7L7|LL7FJ||FJ|F7|||L7|L7|F-J|||L7L7|L7FJFJLJFJF---JLJF-J|L-JL7||L7||||L7|||LJ||L7FJF------J7J7LJL|FL-L7.|-7FFJ
LFL||FFLJL---7L7FJ|LL---7||||FJFJ|F7|L7|||FJ|LJ|L7|L7|||F7||L7L-J|FJL-JF--JLL----7FJF7L--7FJ||FJLJ||FJ||L7FJ|FJL7L7LF-7F--77.J.-7L-L|7|FF-|.
|||F7-|.F7F-7L7|L7L-7.F7|||||L7L7||||FJ||||FJF-JFJL7|||LJLJL7L-7FJL7F-7L---7F7F7FJL7||F--JL7||L--7LJL-JL7|L-JL--JFJFJFJL7FJ-||F|-7|||7FF..J-
JF7||||FJLJFJFJL7L-7|FJLJ||||FJ7|||LJ|FJLJ||FJF7L7FJ|||F----JF-J|JLLJJL7F--J|LJLJF7LJ|L---7|||F7FJF7F7F-J|F--7F--JFJFJF-JL7.F7F7-J|-F-FF|.|.
LFLFLF7L--7|7L-7|F7||L--7LJLJ|F7||L7FJL--7LJL7|L7||FJ||L-7F-7L-7L7FF7F7||F7JL--7FJL--JF-7FJLJ||||FJLJLJF7||F7LJFF7L7|FJF-7L-J|||JF7FJFLL|7-L
F-7-JF7LF-JL---JLJ|||F--JF--7LJLJL7||||F7L-7FJL7||||FJ|F7LJFJF7L7L7|||LJLJL7FF-J|FF--7L7LJF--J||||LF7.FJLJLJL7F7||FJLJFJJ|F--J||FJ|7FFLJJ|FJ
.LJ|-|L7L-7F---7F7LJLJF-7|F7L---7FJ|L7FJL-7||F-J|||||FJ|L--JL||FJFJ|||F---7L7L-7L7L-7L7L-7L7F7|LJL7||FJF-----J|||||F--JF7LJF77||L7L-7-7J.7JJ
J.---L7L-7||F--J|L----JFJ||L----JL7L7|L7F-J||L-7||||||FJF7FF7||L7|F||||F77L-JF7|FJF7|FJF7|FJ||L-7FJ||L7|F-----JLJ||L-7FJL7FJL7||-|F-J.FF7LJ|
L7J.--L-7LJ|L--7|F-----JFJL------7|FJL7||F7|L7FJ||||||L7|L7||||FJ|FJ||LJL7F7FJ|||FJ||L7||||FJ|F7||FJ|FJ||F-------J|F-J|F-JL7FJ||FJL----JL7.|
L--JJ||LL--J|F7LJL7F7F7FJF-------JLJF7|||||L7|L7LJLJ|L7|L7||LJ||L||FJL--7|||L7|||L7||FJ|||LJJ||||||FJL7||L------7FJL--JL7F-JL-JLJF-7F7F7FJ-|
FLF.FF7.F----JL-7.LJLJ|L7L7F-------7||LJ|||FJL7L7F--JFJL-JLJF-JL7|||F7F7|||L7|LJ|FJ||L7||L--7||||LJL7FJLJF------J|F7F---J|F----7FJ.||||LJJ.|
|LF-F77FL------7|F7F--JFJLLJF7F77F7LJL-7||LJ7FJFJ|F-7|7F--7FJF7FJLJLJ||LJLJL|L7FJL7||FJ||F--JLJ|||F7|L-7FJF------J|LJ|F--J|F--7|L-7||LJJJ7-|
|7J-L||7F7F7-F7|LJLJF-7L7F--JLJL-J|F7F7|||FF7L7|FJ|FJL-JF7|L7||L-7F--JL----7|FJL7FJ||L-J|L-7F7FJ|FJLJF7|L7L7F-----JF-7|F-7LJF-J|F7|LJ7|77L.J
J-F-7LLF||||FJLJF-7FJ.L-JL-------7||LJLJ||FJL-J||FJ|F7F7|LJFJ||F7||F--7F-7FJLJ7FJ|FLJF--JF7LJ|L7|L7F-JLJ-L-JL-----7|FJ|L7|F7L-7|||L7F-LJJL-.
|.|F-7F-JLJLJF7FJJ|L-7F-7LF--7JF7||L---7LJ|F--7|LJFJ||||L-7L7|||LJLJF-J|F|L---7L7|F--JF-7||F-JFJL7LJF7F7|F7F7F7F--J|L-JFJ||L--JLJ|FJJ-FJ--||
7-||LLL7F7F7FJ|L-7L--JL7|FJF7L-JLJ|F---JF-JL-7|L-7L7|||L7FJFJ|||F-7FJF7L7|F--7L7LJL7F7|FJ||L-7L7FJF-JLJL7|LJLJLJJF-JF-7L7|L-----7||JJ-|--.|J
F7F-77LLJLJ|L7L--JF----J|L-JL----7|L-7F7L-7F7||F-J|LJ|L7|L7L7|LJL7LJFJ|FJ|L-7|FJF--J|||L7||F7L7LJ|L--7F7LJF77F7LFJF7L7|FJL----7FJLJ7J.L-J-|F
LJFJLJ|FF--JFJF--7L----7L77F-----JL--J||F7LJ|||L----7L7||FJFJ|LF7L7FJJ|L7L7FJLJFJF-7||L7||LJ|FJ|F-7F7LJ|F-JL-JL-JFJL7|LJF----7||7LJJL77J|.JJ
LFL7.L-FJF7FJJL-7||F7F7|FJFJF7F-7F-7F7|||L7.||L7F7F7|J|||L7|FJFJL-JL-7L7L7|L--7L7|-||L7|LJF7LJF7L7LJ|F7LJF-7F--7FJ7FJL--JF7F7|||7.FFFJ-.FF|.
FL.-F7LL7|||F--7||FJ||LJL7L-JLJF||FJ|LJLJFJFJL7LJ|||L7|||FJLJ|L7F7F7FJFJFJ|F-7|FJL7||7|L7L|L7FJL7L-7LJL--JJLJF7LJF7L--7F7|LJ||LJ-.LL|7.-J.|7
J7LLJF7L||||L-7|||L7|L--7L7F7F-7LJL-JF-7FJ7L-7L-7LJ|FJLJ||F----J|||||7L7|FJL7||L7FJ|L7L7L-JFJ|F7L--JF7F7F7JF7|L--JL--7|||L-7|L7JL7-|L-|-L7.J
L77J.LF7LJLJF-JLJL-JL-7FJFJ||L7|7F---JFLJF7F7L--JF-JL7FFJ|L7F-7FJ|||L-7|||F-JLJFJ|JL-JFJF7FJFLJL7F7FJLJLJL-JLJF--7F7FJLJ|F-JL-J|LF.F|7.F.F-|
|L-77|JF-F-7L---7F--7FJL7L-J|FJL-JF7F7F--JLJL-7F7L-7FJFJFJFJL7|L7|||F-JLJ|L---7L7|F---JFJ|L7F7FFJ|LJF-7F---7F7L-7LJ||FF7LJF-77|F7||.FJJJ.|.|
|-7J-FF7JL7L----JL7FJL--JF-7LJF---JLJLJF------J|L-7|L7|FJ7L7FJ|FJLJ|L7F--JF7F-J-LJL7F-7||L7LJL7L-JF7L7|L--7|||F7L-7|L-JL--JFJ-FF7-|-LJJF-|-|
|.LJ.FJ|F7L-------JL-7F-7L7L7FJF-------JF7F--7FJF7|L-JLJJF7|L7||F--JFJ|F7FJ|L--77F-J|FJL-7|F--JF--J|FJL7F-JLJ|||F-JL-7F----JJF7||7J.|.F-JF7|
F-J77L7||L7F--7F----7LJFL7|FJL7L--------J||F-J|FJLJF7F7JFJLJFJLJ|F7FJFJ||L7L7F-JFJF7||F7FJ||F-7L--7|L7FJL7F-7|||L-7F7LJ-F7F7-|||L7LL--J.|LL7
.--|7F|||FJL-7||F--7L----J|L-7|F------7F7LJL--JL---JLJL7L--7L--7||||LL7||FJ7|L-7L7|||LJ||LLJL7L7F-J|J||7FJ|FJLJL--J||F7FJLJL-JLJFJ7.L7|-LL|J
.F-F--JLJL7F-JLS|F-JF--7F-JF-J|L-----7LJ|F----7F--7F7F-JF--JF--J||||F-J||L-7|F7|LLJ||F-JL--7.L7|L-7L-JL7L-JL-7F7F7J|||LJF-7F7F--JJLL7-L.|F77
.-.L--7F-7LJF7F-JL-7|F-J|F7L7FJF-----JFFJ|F--7|L7FJ||L-7L--7L--7LJLJ|F7||F-JLJ||FF-J||F7F7FJF-JL-7L-7F7L-----J||||FJLJF-J.LJ||.|-||-L.L-J|J|
F.FFLJ||FJF7|||F---J|L-7||L7LJJL------7L-J|F-JL-JL-J|F-JF7FJF-7L-7F7|||||L--7FJ|7L-7||||||L7|F7F7L--J|L---7F--JLJLJF7FJ7F7F7LJ7F--7|L--|.J-7
L|FL7FJ||FJ|||||F-7FJF7LJL7|F7FF-----7L---JL-------7LJF7|LJFJFJF-J|LJ|LJL7F-JL-JF--J|||LJL-J||LJL----JLF--J|F------JLJ-FJLJL--7|F-J7J.FL-LL7
FLL7-|FJ||JLJLJ||FJ|FJL---JLJL-JF--7FJF7F7F7F------JF7|LJF7L7L7L-7L-7L7LL||7|77.L---JLJF7F7|LJF-7F----7L-7FJL--7F7F--7FJF--7F7LJL--7--FJ.FF7
FJLLFJL7|L7JLLFJ|L7|L--7F------7|F-JL-JLJ|||L-------J||F7||FJ.|F-JLFJFJ.L||7L-77F7F----JLJL7F7L7|L---7|F7LJF7F-J|LJF-JL7L7.LJL7F-7FJ7LJ-FL-J
|J.FL--JL-J7|.|FJ-LJF7FJ|F---7LLJL------7|||F-7F-----JLJLJ||F-J|.L7L7|.L7LJL|JF-JLJF7F---7FJ||FJ|F---JLJL-7||L--JF-JFF-JFJF7F7LJ|LJ.F-|-|JJ|
.7-|J7|LLL|F7FJ|JFF7||L-JL7F7L7F7F7F---7|LJ|L7LJF------7F7LJL--JFLLJLJ-F7LJ.7-|F7F7|||F--JL-JLJFJL7F-----7LJL----JFF7L7FJFJ|||F-77.LLJLFF7-J
.|JL--JJFF7||L-JF-JLJL7F-7LJL7LJLJLJF-7LJF7L7L--JF--7F7LJL--7L|L7|7FJ|FJLL|7J.||LJ||LJL-----7F7L7FJ|F----JJF7|F7F7FJL-JL-JFJ|||FJJ7L|7FF|L-J
FFF.FLJ-L||||F77L----7||FJF77L------JFJF-JL7|F---JF7LJ|F7F7FJ7JF-7-L7LJJ.|F7F-LJ|FLJJF7F7F7FLJL7|L-JL------JL-JLJLJF-----7|FJLJL7L|-J7FJJ7.|
FF7F7JF-J|||||L7F7F-7|LJL-JL---------JFJF-7|||F7F-JL-7||LJLJ--7FJ.FLL-JJFF|LF-|-FLJF-JLJLJ|F--7||F7LF------7F7F7F-7|F7F7|LJ|F---J.F7FL-J.|-F
L|LJJ|F|-||||L7|||L7||F---7F----------JFJ.LJLJ|LJF---JLJLJ|L|-|FFF7FL|LF--JF-F-F-.-L7F-7F7|L-7LJLJL7L-----7||||LJFJLJLJL-7FJL---7F-7J7|FFJL-
L7J.LF-7J|LJ|FJLJL-J|LJF7||L7F---------JF7F7F7|F-JF7JF7J-LFJ|J||JJL77F7|J.FF-L7|7-|7LJ7|||L7-L7F7F7L------JLJLJF7|F7F----JL7F--7LJFJ.JFFJ7-|
FL|-7.|J7L-7|L-----7|FFJL-JFJL-7F-------JLJLJLJL-7|L-JL-7-J7F7F7.7-7-LJ7L-J|LL|JL7-F---J|L7L--J|||L7F----------J||||L----7FJL7-L--JJF.L-LJ-|
FF|JF7L-L7FJL---7F-JL7L-7F7|F--J|F---7F7F--7F---7LJF7F7FJFF-JLJ|JJ.L.|LL7.F|LLF-7|7L----J7L7F7FJLJ7LJF7F--------JLJ|F----J|F-J7F7F-7|LJ|-LJ|
F-JFJ-7FLLL7F--7LJF-7L7FJ|LJL---J|F-7|||L-7|L-7JL--JLJLJF7L7F-7|J7FL-|F|FF7J7.LLLF7F---7F--J|LJF7F7F-JLJF-------7F7LJFF---JL---JLJFJ-LF-7L7J
.LF.|.L7|FFLJF-JF7|FJFJL7|F---7F7LJFJLJL--J|F7L-----7F-7||FJL7LJF-7FLJ-JJ|L|F7J.F|LJF7FJL---JF7|LJ|L----JF7F----J||F-7|F-7F7F7F7F-JF7.J.|-77
J7LJ|..|FL|.FJF7|LJL7|7FJ|L--7LJL7LL-7F7F7FLJ|F7F7F-J|FJ|LJF7|JJ7F||J|7|-FJFJL-LFL7FJ||F77F7FJ|L-7L------JLJF7JF7||L7LJL7LJLJ|||L-7F|7|7|.|7
F77LJ.LJ-JF-JFJLJ.F7|L7L-J7F7L-7FJF-7LJLJL--7||||||F7|L-JF-JLJJ|L-7J7L7F.|F77|.LF|LJFJLJL-J|L7L-7L-------7F-J|FJLJL7|F-7L7F7.LJ|F7|F7F7-F-|7
||F.|7FLJ.L7FJF---JLJFJF7FFJL7FJL7L7|F------JLJLJ|||LJF-7L-7J|.|-LLJF7|.FF.L-|--FF--JF7F--7|.L-7L----7JF7LJF-J|F---J|L7L7LJL--7|||LJLJ|J..JJ
F|7J|F-7LFFJ|.L-----7L7||FJF7LJF7L-JLJF7F7F7F7F7-LJ|F-JJ|F7L--7J..|7.FJFF--|JJFFJL---JLJF-J|F7JL----7L-JL-7L--JL----JFJ|L-----JLJ|F-7FJ.F--7
L||F7|L7JFL7|-F-----JFJ||L7||F7|L-----JLJLJLJ||L-7L|L-7FJ||F7FJ-J7FFF7.F7.FJ|.FLF7F-----JF7LJ|F7F7F-JF7F-7L----7F-7F-JF7F7F----7-LJL||.F|.F|
LFJ7F7L|-L|LJ-|F----7L-JL7LJLJLJF------------J|F-JFJF-JL7|LJLJL|7F7F|L7|L7||LFF-J||F-----J|F7LJ||LJF7|||FJF---7|L7LJF7|LJLJF7F7L7FF7LJF-77FF
-LJF-7-7FLF7F7LJF7F7L--7FJF-----JF------7F----JL--JFJF-7LJF---7-L|L7L7||FJ-L-FJF-JLJF7F---J||F7LJF-J||LJL-JF--JL-JF-JLJF7F-JLJL-JFJL7FJFJ-L7
..FLFJF7F7||||F-JLJL77FJL-JF7F-7FJFF---7LJF7F7F7F--J-|FJF7|F--JJFL7L-J||L7J|FL7L7F7FJ|L----JLJL7FJF-J|.F7F7L---7F7L7F7FJLJF-7F--7L-7LJFJ|L|F
F--7|F|LJLJLJ|L----7L-JF-7FJLJFJ|F7L-7-|F7|||LJ|L-7F7||FJ|||F--77-|F7FJ|FJF7F7L7||||FJJF7F7F7F-J|.L7FJFJLJL----J||.||LJ7F7|FJ|F-JF7|F-JF-7-J
|J|.F7L-----7|F----JF-7|.LJF77L-J|L-7L7LJLJ|L-7|F-J|LJLJFJ|||F-JJFJ||L-JL7||||FJLJLJ|F7|||LJLJF-JF7LJ-L------7F-JL-JL7F7|LJL7||F7|||L--JFJF|
FF-FJ7JFF---J|L----7L7LJF--JL----JF7L-JF7F7L--JLJF7|F7F7L-JLJL7F7L-JL---7LJLJ|L---7FJ|LJ|L-7F7|-FJL---7F---7FJ|F-7F7FJ|LJF-7LJLJ||||F--7|J-7
|J-J||F-JF--7L-----JFJF-JF7F7F7F--JL---JLJL--7F7-||||LJL-7F7F7LJL7FF77F7|F-7FJF7F-JL7L-7|F7LJ|L7|F-7F7LJF7L|L-JL7||LJJ|F-JJL-7F7LJLJL7FLJJJF
7|J|LLL-7|JFJF7F--7FJFJF-J||LJ||F-7F-----7F--J|L7|LJL---7||||L7F-JFJL7|||L7LJFJ|L-7FJF-JLJL--JFJ|L7LJL--JL7|F-7FJ|L---JL---7FJ||F-7F7L-7|.FJ
.7L|7|7LLJLL-JLJF-J|||FJF-JL7.LJL7LJF---7|L-7FL7LJF7F-7FJLJ|L7LJF7L-7||LJFJF7L7L7FJ|FL-7F-7F--JJL-JF------J|L7LJ||F--7F---7|L-J|L7|||F-J-J7J
F.F77LFF|F---7F7|F7L7||FJF7FJF--7L--JF--JL--JF-JF-JLJLLJ|F7L7|F7|L7FJLJF-JFJ||L7||FJF7|||FLJ7F7|F7JL-7F--7JL-JF-7|L-7LJ.F7LJF--JFJ||||F-7|JJ
.FL|JF-F7L--7LJLJ||FJLJL-JLJFL-7L-7F-JF7F7F7FJF7L----7F--JL7LJ||L7|L-7FJF7L7|F-JLJ|FJL7LJF7F-JL-JL-7|LJF-JF7F-JFJ|F7|F7FJL-7L--7L7|||LJFJ-JJ
F.L|L||||7F7L7F7FJLJF7F-7F--7F7L-7LJ|FJLJLJLJFJL7F7F7|L-7F7L7FJ|FJ|F7||F||FJ|L--7FJ|F-JF7||L7F----7|F7FJF7|LJF-JL|||LJLJF--JF77L7|LJ|F-JJL.F
L|.|LLFJL-JL-J|LJF-7||L7|L-7||L--JF-7|F------JF7LJLJLJF7LJL7LJFJL7||LJL7||L7|7F-JL7|L-7||||||L7F--JLJ|L-JLJF7L--7|||F7F7L---JL-7LJF7LJJ||F-J
||-J|LL----7F7|F7L7LJL-JL-7||L----JFJ||F------JL----7FJ|F7FJF-JF7|LJF--J||FJL7L7F-J|F-J|||L7L-JL7F7F7L--7F7|L7F7|||||LJL7F-----JF-JL-77F77|F
LLJL7JLF---J||||L-JF--7F7FJ||F7F---JFJLJF-----------J|FJ||L7|F7|LJF-JF--J||F7L7|L--J|F-J||FJF7F-J|LJ|F-7LJLJ7LJLJLJ|L--7|L-7F7F7|F--7L7FLJ7J
L|F7.LFL7F-7||||F--J7FJ||L-JLJLJF7F-JF7FJF7F7F-7F7F7FJ|FJL-J|||L-7L-7L-7FJLJL7|L7F7FJL-7|||FJ|L-7|F-J|JL----7F-7F-7L7F-J|F7LJLJLJL-7L7|7|.|L
FFL-|-FFJL7LJ||||F--7L7|L7F7F---JLJF-J|L-JLJLJFJ|||||FJL---7LJ|F-JF7|F-JL7LF7|L7||LJ-F7|||||FJF7LJL-7|F-----JL7|L7|FJL7-LJL-7F-7F7FJF|L7J.J.
F|7F-7LL--JF7LJLJ|F7L7||.LJLJ7F7-F7L-7|F-7F7F7L7|||||L7F--7|F-JL-7|LJL7F7L-JLJFJ|L7F7||||||||L||LF7|LJL---7F--JL-J|L--JF---7|L7LJLJFLL-J-7F7
JJJ.|-7||F7||F7F7LJL7|LJF--7F-JL-JL--JLJ-LJ|||FJ|LJ||FJL-7LJL-7F-J|F7FLJL----7L7|FJ||||||||||FJ|FJ|F7F----J|F-----J.F-7|F--JL-JF-7-F-|J|.LLF
LL|F|L7-FJ||LJLJL7F-JL-7L-7|L--7F---------7LJ||FJF-J|L--7L--7FJL-7|||F7F7F7F7|FJ||FJ||LJ|||||L7LJFJ||L-----JL------7L7LJL7F7F--JFJ7|7J.|FFLJ
|L-F-7F7L7|L----7|L--7FJF7|L--7||F--------JF7LJ|FJF7|F--JF--J||F7|||||||||LJ|||FJ||FJL-7|||||JL7FJFJL7F77F--------7L-JF-7LJLJF7FJ7L|7FF|-7J.
7-LFJL||FJL7LF-7|L---J|FJ||F-7LJ||F--7F---7|L7FJ|FJ|||F-7L--7|FJ|||||||||L-7||LJFJ|L---J||LJ|F7|L7L-7LJL-JF------7L--7L7|F7F7||L-7--7-|LJLLL
J7.F7.||L-7L7L7|L---7FJL7|LJJL-7|||F7LJF--J|FJ|FJL7|||L7|F7J||L7LJ|||||||F7||L7FJ-L7F---JL7FJ|||FJF7L7F7F7|F--7F7L--7|FJLJLJLJ|F7L7|F-L7JFFJ
||-||FJL7.L7L7||F7F-JL7FJL-----J|LJ|L--JFF7||FJL-7|||L7||||FJ|FJF-J|||||LJ|||FJL--7|L---7FJL7|||L-JL7LJLJLJL-7LJL7F-J|L-7F7F-7||L7|7|..|.FJF
|L-.FL-7|F7L7LJLJLJF-7LJF7F7F-7FJF-JF---7||||L7F7||||FJ|LJ|L7|L7|F7||||L7FJ|||F---JL7F--JL-7||LJF---JF--7F7F-JF7L|L7.L-7LJLJFJLJ-LJ77J---7.7
JJ..F--J|||JL7F-7F7|FJF7|||||.LJ.L-7L7F-J|||||||LJ|||L7L-7L7|L7||||||||FJL7|LJL--7F-J|F7F7FJLJF-JF--7L-7LJ|L--JL7L7L-7-L7F7FJ7.L-|JJFJ||-L-F
|||7L7F7LJL--JL7|||||FJ||||||F----7|L||F-J||L7|L7|||L7L7FJFJ|FJ|||||||||F7||F----JL-7|||||L--7|F7L7FJF7L-7L---7FJ.|F7|F7LJLJF7F7L|-F|--J-7|.
FLF-LLJ|F7F7F7FJ||LJLJFJ|||LJ|F--7LJFJ||F-J|FJL7|FJL7|FJL7|FJ|FJ||||LJ|LJ|||L7F--7F-JLJ|||F7FJLJL7|L7|L-7L-7F7LJF7LJLJ|L----J|7|.|F||LJ7-7LJ
F-J-JFFJ|||LJLJ|LJF--7|FJLJF-J|F-JF7L7|||F7||F7||L7FJ||F7|||FJL7||||F-JF7|||FJ|F-JL--7FJ||||L7F--J|FJL7FJF7LJL7FJL7-F-JF-----JJF7|7LLJL-77|J
LF|LJLL-J|L7|F--7-L-7|LJF7|L--J|F7|L7|||||||||LJL7||FJ||||LJ|F-J||||L7FJ||||L7|L7F7F-JL7||||FJ|F7FJ|F7||FJL7F7LJF7L7|F7L-----7F|J-7FJJ|L|-7|
FLLJFL|J|L-J-L-7L---JL--JL-----J|||F||||||LJ|L-7FJ|||FJ|LJF-JL-7|||||||FJ||L7||FJ||L-7|||||||FJ||L7||||LJF-J||F7|L7LJ||F7F7F-J-7J.77.FL.F7L7
7-J-J.7.-F7|JF7L---7F7F7F-7F----J|L7||LJLJF-JF7|L7|LJL7L-7L7F--J|||L7||L7||FJLJ|FJL7FJFJ|||||L-J|FJ|||L-7L7FJ||||.L7FJLJLJLJL|7.F7.F-|...FJL
J|LJ7F7--|L--JL----J|LJLJFJ|F----JFJ||F---JF7||L7||F--JF7|FJL-7FJ||FJ||7||||F7FJL7FJL7L7|||||F--JL7|||F7|FJL7||LJF-JL7F7F--7.F7.F7F|LJFFLFJJ
FFJ|LJJJJL7F7F--7F7FJF---JFJ|F7F7FJFJ||F7F7|||L7|LJ|F-7||||F7FJL7||L7LJFJ|LJ|LJF7||F7L7|||||||F-7FJ||LJLJ|F7||L-7|F-7LJLJF-JFJ|FJ|7FFJFL7||J
|JL-7L|..LLJLJF7||LJFL-7F-JFJ||||L7L7|LJ||LJ||FJL-7||FJ||||||L-7||L7|-FJFJF-JF7||||||FJ||LJ||||-|L7||F--7|||||F7||||L-7F-JF7L7||FJ7.LJ|F7-J.
7.FLF-|--J|LJFJLJ|F-7F7LJF-JFJ||L7|FJL-7LJ|FJ|L7F7|LJL-J||||L7FJ||FJL7|FJLL-7||||||||L7|L7.LJLJFJFJ|LJF-JLJ||||||||F--JL--JL-JLJL-77F-77|F|7
LJ|LF--7J.|JFL7F7|L7||L-7L-7L7||.||L7F-J7F7L7L7|||L-7FF-J|||FJ|FJ|L7FJ||F7F-J|||||||L7|L7L7F---JFJFL7FJF--7||LJ||||L7F7F---7F-7F--J77FL7J7J.
|F-7|J.L|-L.77||||FJLJF7L--JFJLJFJ|FLJF7FJL7|FJ|||F7L7L7FJLJL7|L7L7||FJLJ|L7FJ||||LJFJL7|FJL7F-7L-7FJL-JF7||L-7|||L7|||L--7|L7|L7J|.J7.FJ7F|
7-F7J|FFFJ.FF-J||||F7FJL7F-7L--7L-JF--J|L-7LJL7||||L7L7||F7F7LJFJFJ|||F7FJJLJFJ|LJ|FJF7||L7FJ|JL7FJL--7FJLJL--JLJ|FJ||L7F-JL-J|FJ7L7FJ7..LJL
L-7..FFL|F7-L7FJ||||||F-J|FJF-7L7F7L--7|F7L7F-J|||L7L7||LJLJL7FL7L7||||||F7F7L7|7F7|FJLJL7||FJF-JL--7F|L-7FF7F-7FLJ-||FJL7F7F7LJ7F7LJ.-F|F||
F|L|7F77LL.|FJL7LJLJ|||F7|L7L7|FJ|L---JLJL-JL-7LJ|FJFJ||F7F-7|F-JFJ|||||||LJL-JL-J||L-7F-J|LJ.|F7F-7L7|F7L7|LJFJF--7||L-7LJLJL---J|-7J.-FFJJ
FLFJ-F|JJ7|-L--JJLF7||LJLJJL7|||FJF7F7F7F-7F7FJFFJL7L7||||L7||L-7L7LJ||||L7F7F7F7FJ|F-J|F7L-7FJ||L7L7|||L7LJF7L-JF7|LJF7|F7F-7F-7FJ7|F-|LL7J
||.L-FJ.FLJLL7|F77||||F7F7F-J|LJL7|||||||||||L-7L7FJ7LJ|||FJLJF-JFJF7LJLJFJ|LJ||||-LJF7|||F-JL7|L7|L|||L7L-7|L---J||F-JLJ||L7|L7|L7-77.JFLL.
|7-.F|-F|-L|JF-JL-JLJ||LJLJF7L-7FJ|||LJ|L7LJL-7L7|L7F--J|||F--JF7L-JL--7L|FJF-J||L---J|LJ|L7|FJ|FJ|FJ||FJLFJL----7LJL-7F-JL-JL7|L-JJFL-|7LL.
|J|--7-|J7.J7L-7F---7|L7F7FJL-7|L7||L7FL7L7F--JFJL-JL7F7|LJ|F7FJ|F-7F-7|FJ|FJF7||F-7F7L-7L7L7L7|L7|L7||L-7L--7F-7L7F7FJL--7.LLLJ7LL-JJF|77-7
77L-J77F--77|.L||F--J|7||||F--J|FJ|L7|F-JFJL7F7L----7|||L-7LJ||FJL7LJ-LJL7|L-JLJ||FJ|L7FJFJFJFJ||LJ.LJL7FJF-7||FL7LJ||F7F-J7JL|L-|L7LL|JJFF7
L-LFJ|L|--F7L-JLJ|F-7L7LJLJL-7FJL7L7|||F7L-7||L7F7F7|LJ|F-JJFLJL-7L---7LFJL7F---J|L7L7|||L7L7L7|F-7F7F-JL7|FJLJF-JF7|LJ|L7JJ.FJ-|L.|.LLJFLJJ
L|LJ.-.|--LJ7FF|LLJ-L7|LF--7FJ|F-JFJ|||||F7|||FJ||||L-7|L7|FF----JF---JFJF-JL7F7FJFJFJ|L-7|FJFLJ|FJ||L7F7LJL--7L-7||L7.L-J-F-LJJL-J-7.|7FJ|.
-77-L7FL.FJJJL7J-JJ||||FJF7LJFJL7FJFJ|||||||LJL7||||F7|L7L7FJF---7L--7|L-JJF-J||L7|FJFJF7|||J|.FJL-JL-J|L7F7F7L7FJ||FJ-|||-JJ|77F-|FL7.7|L-F
|.L-JJ--FJJ7.JJFFJ-77LJL7|L7FJFFJL7L-JLJLJ|L--7||||LJ||FJFJL7|F7FJF7FJF7F--JF7||FJ|L7|FJ||LJFF7L7F-7F7FJFJ|||L7|L7|LJL|JL|7L7-L|J.LLL-.JF|F7
L7.L.L|J|7JF7--7--7L-LFFJ|FJ|F-JF7L----7||L7F-JLJ||F7||L7|J-LJ|LJFJ|L-J|L---J||LJFJFJ||JLJJF-JL-J|F||LJ-L7|LJ|||F|L----7.|F7|.FJJ-7|FL-J-L7|
|7--F-77JLF7.F7|J.FL-LFL-JL-J|F7||F-7F7L-7LLJ.F--JLJ|LJ.LJLF|7L-7L7|F-7L----7LJ7FJFJFJL7J|FL7F--7|FJL--7FJL-7FJL7|F----J-77|J-FJJ.J7J7-FFL|7
.J.F7..FJ|LF7J77.J.F|.LL|L|7LLJLJLJL|||F7|.LJF|F7F-7L---7-FFF--7|FJ|L7L7F-7FJLF-JFJJL7FJ-|-7LJF-J|L-7F-JL7F7|L7FJLJ.|.||FL-LJ.-.|7-7-7.L7J.7
L7.77.F77|F|||F.|.|7.FFFJ.LJ7-|JLL|LLJ||LJ.L-J||||7L7F--J-F7L-7LJL7|FJF|L7LJ|||F7L7|||L7.|LFF-JF7|F-JL--7||||L||.LJJ-77F|JLJ|F7FFJ.|FJ.||FFL
F77|77J|JL-L7FJ-7-F77FFJ.FF.7-L7FF|7-LLJJFFF|JLJLJF-J|JL|7|L--JF7FJLJ7FJFJJLLFJ||FJ7FL7L7J|FL7FJLJ|F-7F7|||LJ-LJ77.L||7JJFF7F|--7-7F7|-FJ7L|
LJ|JF-JLL7|JLJFLLFJ-7-|J.F|7|LLF7L|L77|7LLJJ|FF|.FL-7L--7-|F7F7||L-7JLL7L7J7LL-JLJ.F--JFJFJ|||L-7FJ|L||LJLJJ.|J..LL-7.L7|LL|-J-||LF7LJLF-7.|
F-.-JL-JL-JFF|7-|.-7JJ|JFFJF-7F|JFJ-L|7J7L|.|FLJ-FL-|F--J|LJ||||L7FJJLLL7||LFJ..LJFL---JJ7.FFL7FJ|FJFJ|7|LLJ|J.|J-|L7.|FJ7.-JJFL7.FJ|LF-7.F7
FJ7|L-F--J.-FF.F7-7...J7J|F|LJ-7.LL7|.|-|.|-|L|J|J.FLJL|7|7LLJ||FJL7JF-LLJ7FJ.L.FFJLLJLLL.F-77LJJLJ-L7L-7J|-L77|||F-L-J7..J||F7L|F|-|7JFL--7
F7|7J7F|-FJF|J-LJJL-7.LJ-JFF.J|.|7L||F|..-.LL-77F7LJFL-L--7||FLJ|F7|F||LLL|-LF--L7F-J|LLLFF7|LL7JJ-FL|F7|7|F7--J-FJJFFL77FFFJL--J7JJL|-7J7L7
|LJL7LLJ-LJ-|.F7L-LL-F.L|7JL7FF-L77F|7.F|L7.L-J-L77-JJFL7|FL|-|J||LJ7F7..L|FFL7JL--|LFF-|.L-JJ-JJ|JJLLJ||-F7.|LJFL.FJJLLF7-J|.LLLL7F77-JJL-J
L7FL|J||7|FF7FF|L-.J-JJ|J|L-F-7.|.|L|-7-|-J7.|FL|-J.|F|7FL|J||L-LJ.|-JJFJ-JJ-JLF.|.F-F.LJ7|.LF7J.|..FFFLJJLJ77L7||7L7|.|L||7|L77FLLJLJLF-J.|
|7|FJ7F-J77.F7JJ.LFJ..L-F--F|L.FFL.7J.LLLJFJ-7J.L7JFJ7|FL7-.F|F7JJ7L|7F7-77.F-FF--7|FJ7|LF|7-F|7-|7.F7-LJ|.L--7JL|JJF7F7.|L-J.F-|J.L-J|L7|F|
FJ-7.J|-FF7FLJ|LL-|7-F7.FJF-J.F|.LFJF77-JF-|L|.L.JF-.LLJ7J.-J.J.|-F7L-JFJL-|J|LL-FJL-7F7|.L-7LJ|.LJL-|J|L|7-|F|7J|.LJL-F7JL--F|-FF7JJF7|L-7.
L.L--.J.L7-7JJL.|-JL-LL-7L|J-L.FJ-JLLLJ.L7J|JJF-7JJ.LJ.L--FJLLJ.J-J-JJ.L--|L-L.L-F.JLFLF-J-|-.L|---LL7JJ.L...|LL.-LF-FLFJJ7---JJJ|JL-J.L-L--
