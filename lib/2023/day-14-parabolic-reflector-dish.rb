=begin

--- Day 14: Parabolic Reflector Dish ---

In short: if you move the rocks, you can focus the dish. The platform even has a control panel on the side that
lets you tilt it in one of four directions! The rounded rocks (O) will roll when the platform is tilted, while the
cube-shaped rocks (#) will stay in place. You note the positions of all of the empty spaces (.) and rocks (your
puzzle input). For example:

O....#....
O.OO#....#
.....##...
OO.#O....O
.O.....O#.
O.#..O.#.#
..O..#O..O
.......O..
#....###..
#OO..#....

Start by tilting the lever so all of the rocks will slide north as far as they will go:

OOOO.#.O..
OO..#....#
OO..O##..O
O..#.OO...
........#.
..#....#.#
..O..#.O.O
..O.......
#....###..
#....#....

You notice that the support beams along the north side of the platform are damaged; to ensure the platform doesn't
collapse, you should calculate the total load on the north support beams.

The amount of load caused by a single rounded rock (O) is equal to the number of rows from the rock to the south
edge of the platform, including the row the rock is on. (Cube-shaped rocks (#) don't contribute to load.) So, the
amount of load caused by each rock in each row is as follows:

OOOO.#.O.. 10
OO..#....#  9
OO..O##..O  8
O..#.OO...  7
........#.  6
..#....#.#  5
..O..#.O.O  4
..O.......  3
#....###..  2
#....#....  1

The total load is the sum of the load caused by all of the rounded rocks. In this example, the total load is 136.

Tilt the platform so that the rounded rocks all roll north. Afterward, what is the total load on the north support
beams?

--- Part Two ---

The parabolic reflector dish deforms, but not in a way that focuses the beam. To do that, you'll need to move the
rocks to the edges of the platform. Fortunately, a button on the side of the control panel labeled "spin cycle"
attempts to do just that!

Each cycle tilts the platform four times so that the rounded rocks roll north, then west, then south, then
east. After each tilt, the rounded rocks roll as far as they can before the platform tilts in the next
direction. After one cycle, the platform will have finished rolling the rounded rocks in those four directions in
that order.

Here's what happens in the example above after each of the first few cycles:

After 1 cycle:
.....#....
....#...O#
...OO##...
.OO#......
.....OOO#.
.O#...O#.#
....O#....
......OOOO
#...O###..
#..OO#....

After 2 cycles:
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#..OO###..
#.OOO#...O

After 3 cycles:
.....#....
....#...O#
.....##...
..O#......
.....OOO#.
.O#...O#.#
....O#...O
.......OOO
#...O###.O
#.OOO#...O

This process should work if you leave it running long enough, but you're still worried about the north support
beams. To make sure they'll survive for a while, you need to calculate the total load on the north support beams
after 1000000000 cycles.

In the above example, after 1000000000 cycles, the total load on the north support beams is 64.

Run the spin cycle for 1000000000 cycles. Afterward, what is the total load on the north support beams?

=end

ParabolicReflectorDish = Data.define(:lines) do
  def self.parse(text)
    new(text.lines(chomp: true))
  end

  def height = lines.length
  def width = lines.first.length

  def each_position(backward: false)
    unless backward
      (0).upto(height-1)   { |r| (0).upto(width-1)   { |c| yield Position[r, c] } }
    else
      (height-1).downto(0) { |r| (width-1).downto(0) { |c| yield Position[r, c] } }
    end      
  end

  def rock_at(pos)
    pos => row: row, col: col
    if (0...height).include?(row) && (0...width).include?(col)
      lines[row][col]
    end
  end

  def set_rock_at!(pos, rock)
    pos => row: row, col: col
    lines[row][col] = rock
  end

  Position = Data.define(:row, :col) do
    def neighbors = [north, east, south, west]
    def north = with(row: row - 1)
    def east  = with(col: col + 1)
    def south = with(row: row + 1)
    def west  = with(col: col - 1)
    def to_s = "#{row},#{col}"
  end

  def tilt!(dir)
    backward = (dir == :south || dir == :east)
    each_position(backward: backward) do |pos|
      if rock_at(pos) == 'O'
        last = pos
        cur = pos.send(dir)
        while rock_at(cur) == '.'
          last = cur
          cur = cur.send(dir)
        end
        set_rock_at!(pos, '.')
        set_rock_at!(last, 'O')
      end
    end
  end

  def tilt(dir)
    tilted = self.class.new(lines.map(&:dup))
    tilted.tilt!(dir)
    tilted
  end

  def cycle
    tilt(:north).tilt(:west).tilt(:south).tilt(:east)
  end

  A_BILLION = 1_000_000_000

  def cycle_a_billion_times
    history = []
    last = self
    A_BILLION.times do
      history << last
      cycled = last.cycle
      seen_before = history.index(cycled)
      if seen_before
        cycles_to_repeat = history.length - seen_before
        return history[seen_before + (A_BILLION - seen_before) % cycles_to_repeat]
      else
        last = cycled
      end
    end
    raise 'wow, a billion times wthout repeating!'
  end

  def total_load
    load = 0
    each_position do |pos|
      if rock_at(pos) == 'O'
        load += height - pos.row
      end
    end
    load
  end

  def total_load_when_tilted(dir)
    tilt(dir).total_load
  end
end

if defined? DATA
  dish = ParabolicReflectorDish.parse(DATA.read)
  puts dish.total_load_when_tilted(:north)
  puts dish.cycle_a_billion_times.total_load
end

__END__
O.OO.#...#.O#...#...O..O.#O..O.##.....###O.O##O.O....OO.....##..##.#..O#.........O#..#..O...#O.....O
.....###.O....#.#O.....##..O##O.......##......O..#..##.#.O#...O...O.O....#.###O.OO#.#O.#.#..O..OOO..
OO......#.#..##O........O.###..#.#........O#..O....O#.#.##.OO.....O#.........###O......#..#.O..#....
..#O...O....#.#.#O#....#.O#....OO.OO.O#...O##.O........O.#O.OO.O.....O.#.O.#....O.....O..OO.OO...O.#
..#O...#.....O#O...###O......O#.##O..O#.O.O.#..#O#.O....O..O#...OO...O..#.O.......O.##OO.#...#...##.
.#......O.OO#....O#O#OO.O..O......OOO..O....O....#OO....O...#.O.O.O..O...OOOO...#......O..#O..#O....
..O.#.O.#..OO...........#..#......#.#...#...O...#...#...O##..O..#..O.#...O..#.O...#....#..OO..O..#.#
.##..O..##O......#...##....#..#..O....#..##.#.O#....O#..#...O.O....O.O.........OO.#.OO......O.......
..##O.O...O.O..O##OO..#.O..O.#...O..#..#.O...O....##...#O...O......#.....O##O#..O.#..#..O...#...#.O.
O..##...##...#.#.OO#...OO#O..O...O.#O..#.O......O##......#O..O..OOOOOO..O.##.O...#O.....O##......OO.
.........O..O#.....#...#......OO###OO.O.O#...#.O....O..##..O#.....O.#.##O.#......#.O.....OO#.#..##O.
OO#O...#...OO.O####.OO.#.#.......O......O#..O#..#...#O....#.....OO#O......#O#...O#.OO......O....O#..
.O.........#.#O#....#OO..#.........OO....O...#.O.O.O.OOO.O..O.....O.#....OOOO....OO.......#.#.O.##..
....#.....#.O.#O...O#OO#...##.#.#..O.O.O....#O.#.#.O...#O#O.O#O...O..#OO..O###.OO..#.....OOO.#......
#OOO..OO.O.O..O..O....#....O..O.#...O...O...##.O##..O...OOOOO#.........OOO##..#...OO#O#O.....O...##.
.......O#..#OO.O.O..OO.O#..O.......##....OO#.O..O..O#...#..#...O.##.....#..........#.....#.O...#...O
......O.#.O...O.......O#..O..OOO#...#........###.O..#....O.O#.OO.O..#.O#O.O.O.......O.##.OO......O.#
O....O..........#....##.###..#...O#.O..O.##.O....O..O..O..##.O.O#OO...O.#.O##..#.#.......#.O..O..O.O
..O#..O.#.##..O#..O#..O..O..O....OO...O##..#...O.OO..#.#.#.###O.O...#O.##..#.....#..#O.O.O...#O.O#..
..O.##........OO.....OO.O..#.....OO.O..#...#..OOO..#....#....#.OO.#.#........OO...O.#O....##O..OOOO#
.........#.#.OO.#O...#...O#........O..#.#........O......O#.OO..#..#....O##OO.......O..O.O.O.........
#..O..#..OO.O.O....O..O.O.#.O.O#O...O.OO..#......OO.#..O....#.....#OOO#.OO#.OO........###....O.....O
..O..O.O.O.....O..#.O..##.O..##..O###........O.O..#...O....OOO#.OO.#O...O..##....#.#O...#..O...O...#
O#...O..O.#.#......O..O.#OO.....O..#.......O.##O........#O.OO..#..O.##..O.#...O...#O.....#.#..OO##..
O.OO..O....O.#..O##O.#.O.O#O..##...O..##...#.O#.....O##.#O..O.O.....O....##..O.###......#........O..
.....##.#.......O.OO....#..##............##..O..#.......O..O..#.O...O#..O.O.##..O..OO.O.....O...O...
##.O.#....O..OO..OOO.OO.##..OO.OO.#...O#.....#...##...O#....OO..O.O...O...O.#....OO...#..#O#.##..#..
........OOO....O...#.O...O..#......O....#O#.#O...O#.O........O.O...OO#....O..#.#.#O.O...OO....O.#O..
OO...O...O..#.OO..O#.OO###..O.......#..O..O.####O....O.O.O#O.#..O..##OO..O..#....#..O#O....#..O...O.
..O....#.O.O....O...#.........#..O#.#..OO....#...##.OO..OO.O...OOO..O..O#.###.......O#...#....OO...#
.O...OO.O.O...#.......#.O.O.....O...OOOO.#O.O..O..OOO.OO...............#O...##O..OOO##....#O.O#.##..
O....O...O.#...........#..#.#OO###O.O...#.O#..O.....O...O....O...#...O.OOO.OO#..OO...#..OOOO...#..#.
....O...OO.#.O...O..#....O.O.#O..O....O..O..##O.#O....O..O.....O.......OO.......#OO#.##.O.#.O..#.##O
#OO#.#....###O#..OO..#..O.......O.O...OO#.#O.....O.O##.O...#.##O#...O#......#..#..O#O.O.....OO.O#.O.
...O#....O...O......#..O#O..OO.O#.OO.#.......#...O..O.....O.#O..O..O.....#OO#.O..#....#O.#O..#......
..O.....O.......#O....O#...##.....#..O.#....#.#.#O#.#....O....#..O.O......OO....O.#OO#OO.....O......
.#..O..#..O##...#O.#.##O#.#.#O....O#..###.OO..##..#..........O#O.#..#....O...##.......O.O.O##O#..#O.
.#.....O..O.#..#..O....O...#.....#O.O.....OO.#..#......##........O.#.#......#...OO#....O#O.....#..O#
#.....O.....O...O..##O.OO#OO......O#..O......O...O...#.....OO..#...O..#.....##.#.O...#..#O......OO.O
.#..#.#.#...O#.......#.O....O..#.#.#.....O...................#.O...OOO#.....O.O.....O..O.#.....#.O.O
O....O.....O.....O#O...O.O.O#O.#O..OO#OO..#OO.OO##.....##O#.O.O..#.....O..OO.##.#.......#...O..OO.O.
.O#..O..#....##......O....#.#.#......#........##...#....#.......#.....O......##.#.....O.O....OO#.O..
....OO.OO#...O..#O#O.#.O.#..OO...OOO...#O.#..#..#.#O...#O.#.O..##..O.##..O#.#.....#..O...#.O...O#.O#
....O#....O.O#OOO...#.#.........O.O....#..O...#...#.....O.O.O.O....#.OO.##O.....#.#.#.#O..O#.O.#.OOO
O#OO..O.#.......###..OO..O........O.##O.#O##..O...O.#OO.....#...O......O.OO...O..OO....O..O..#.#...O
.#.O.O.O.#......O......##O...OO.....O....O#.....O#....#.......#O..#...##..O..#O.O.O..O....O.........
...#.........OO..O.O#..O.#....#...OO##...O..OO.......#.#OO..#...#..##.#...OO#...#O.#...O.....O...#..
#.....#O......O....O#.....#.#O.OO..........O.O...#....#.###O.O..O...#...#..#....O..O..O#.O.........#
O.O.O...O...#.....#.#....O.O.O.....OO....#..OOO......O.O.......O#O...#.#O##O.####.........O#O.......
O.O...........O#...OO..#O.O.O......O.......##.O...O..##...O.#OO...#OO...#...#O#.##O.#......O.##....O
O..#...........O..O......OOO....#....OO.O...#O..O.O#......#...........#O...#O..O....#.#.#..#...#O...
..O.....#...#...O.#.O..##.........O#..##.....#O.........................##...#.#..#.OO#O...#OOO#O.##
OO..O.O.....O#.O....O##...O.O#.OO.#..O.....O...##.O#..O......OO..#..O.....##.....OO#OO...#O......O.O
.OO...#....#O..#.....OO..O.O.......O#...O#..O#..#.O....#.O.#.O...O.#.O.#...#..OO.......O#....OO..O..
O.OO..#.OOO.#.O#...#.#..O..O#.#.#.#.....#.O#..O....O..OO...O..#..#....OO#O.#......O#..##...O...O.#O.
....#....#...OO#...O.O#OO.#.#OOO..O...OO.O..#.O#..#..O.O..#.#........OO#O.#.#.#.....OO......##.#.O..
.#.O.OOO#OOO...##O#.#...#...##O.#...O.......###O#.##..O#..#.##...O..O.O.........O..#..O##......#.##.
O...#..#....#O..##..O.O##..O.O###O.......O...#.O#.O#..O...#.#.O..#.....#.....O..O..OOO.OOO..O..OOO..
...O#.O....O.O.#.O..#.O..####...OO......#OO....O#....O..O...O...OO..OO.OOO#....#..#.O.O..#..#.....O.
O.O##O.O.O.#.O.#........#O......#O.##...##OO.......O#..#..#.O....OO........#.#O..#O.........OO.O#..O
.......#.....O...O.O.#O##.O.OO#.....O.O#O....O.#.##.#.......##.O.O.###O...O.O#O##...#...#...O..#....
.O#...#O...#....O##.O..........O.O.#..O.O..OOOOO.......OO.O#...O...O...#O###OOO.#OOO..............O#
O.#.#.......OO..OO.#.O#.....#.O#O...#......O....O...O.O.....OO.#O.......#..O...O.....##OO#.....OO#.#
...O#...#.....#..#O.#..O..O.#O#O.#...OO#O.O....O.#...#O#O....#......O..#O...#....O..O.O........#..#.
.O.......#..O#...O....................#.##O......#.#......####..OO#...OO.##..#........#.OO..#OOO.###
......O...O..O##.......O...O##O.O....#..#.##...#OO..##..........#..............##O.......O...#O###O.
.........#..OO.#.......OO...O....#O.#.......O..##...###..O...#OO.O.O...#...#OO....##O.....#O.O..#...
..#....O..O......#.#....OO#....#...O.#.OO.O#.....O#.#......O.#O.........O....O....#..O.........O....
.OO.......#.....O.O..O#....O.#.....O..O#O...O#.....OOO....##..O.O..O#.OO...#....#...O..#..##..#..#.O
O..#..OO##.#..OOO..#...#.OOO..O..##..O..##O.......O.O..O...#.O...#..###.#.#.#...#O..O......#.O#....#
...O..#O..O..OO.#....#...##...O...#.......OOOO#...O.###.O.......#O.O#.##.##O..#...O...O.O..#....OO..
OO.........OO...O.O............O....O.O...O.O.O.......O.OOO.O#....#O.O..#.....O#...#...#....#......O
#.OO#........OO..#OO.....O.#...#..#O.O...O.....#..O.......O...O..O...O.O.O....##...O....O.OO.....#.O
..O....#..O....O#.....#..#O......O......#...#O.......O.O...##O.#...O#..O#.#O###...#.OOO.#O...O#....O
.#.#..OO.#..O###....O.#......O..OO...O.O..O.#.O....O.#..O.....O#....O....#.......O.O...O......OOO.#.
...OO#.OO#O....O....O.O.#.O.#O..#.O#...###...#......#...OO##.#.#..O#...#....#.#.#.OO....O...OOOO...O
..O.#..O...O...O#O......##.....O...O..O....#....O..#OO.#.O......#O.OOO.O.O..#........##...#O.#O...O.
..O.OO.....O...#..O..#...O...O..#O..O#..##.....#....#.#O.#.......#O##....O.OOOOOOOO#.O...O.O#..#O##.
O.OO.####..OO...OO.O........OO#.O.O...#....#..OO......O.O...O..#.##....O....O......#O........#O.O#..
.#O.#...#.#...OO#.O.#O.....O##.O.OO.O..#..#O.....O...#.O.O#.....###.....#O.O.......O.#O.O#..#.O..#..
.O......O........O...#O....##.....#O..OO.O..#.....O.#..O...#O#.#..##.#O..........O.O.O..#....#..#..#
.OOO..O...#O.O#..#....O......O.O...O#O.....#..OO......OO.#O..O..O###......O.#.#.#.O....#...O........
.##.....#OO#.##.....#....O..O.....OO..OO##...O...O#.##.OO#....#.......#...O.O.#.O........OO...OO....
......OO#.....OO#OO......#.O....##..O.O#...O....#..O.O.#O.#...#.O..#.O.O#O....O.O..O.O.O.#OO.##.OO.#
.O..OO##....O###......####.OO...O#..#..##.##.O..#..##OOO...#..#O##.#..#........#...#....O.......#.OO
..O..O.O..#....#.#O.#.#OOO....O.##.....OO....#..O...#...#O.........O....O..#..........#.O..O.OO.O##O
OO.......#...O#.#.......O...O.OO#.O.O.....O.....#...##..#....#.......O#.#O..O.O.......##...OO..#O...
#O#....#.#.O..#...OO...##.#.#.O#O#...#........O..OO..#..O#..O..O.O.#O...#.....#O.#O.O#..OOO#.O.O..#.
.#O...OO.##.#.....O...O#O................O.O..O#...#..O.#OO..O....OO...O.#...O#.#.O...O#....OO#.#...
O#...###.OO.O...O.O#O#..O.O...O.#.....O......O...#...O.O....#...O...O#.#...##....O...........#O...#.
.....#OO.#.OO...##.O....#OO#.....O..##...OO#.......O...##..#....#..#..##.#O.O##..O.#.O.#.O#OO.O.#.#O
O##.#..O.OO..O.O.OOO.O...O..O.O..O.O.O..#.........#.....OO.#.......O#....#.......#O.#.O..#...O#..OOO
.#....O.O..O##...#.OO#.O#..#OO..O.#...O....##.#O.O#O#...#.........O.#..#....OO..O.#........##O.##O..
.....#....OO#...#.OO.O.O....O..#O.#.O#.O##.O..#.#O.#..O.#.O..O#.#.O.O.O#O....OO#...O......OO#..OO#O.
O..O.#O..OOO..O...O...#.......#O.OO....O..#...O.....O.#.OO....#.O.OO...O#...OOO###.O..#.....O..O#.#.
.OO......O#O.......OOO.......O..O...........O..##.....OO..##...O.O.O...O.O.O.....O..OO..O#....#.O..#
O....#....#O.####.O...#....O....#O..#O...O.O....O.O#..O.........O#.......O....O..O...#.##..O.OO.OO..
.O###O...#OO.OO........O.O#.O.O....O.O...##.O#..###..........#..O#.O..O.OO.O..#O#OO..O#.O.##.O.OOO##
#.#O#..O.#...O#..#.......O#..#...#...#O..#.O.....O...O.......#O.#...#OO.O....OO..O...#.#....#O......
..O.#O.O.O#..#.O...#.....#..O..##..O......O.OO.O.###.....#.O..O...OO#.OO.....#...OO#O..#..#O#...O..O
