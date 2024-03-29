=begin

--- Day 22: Sand Slabs ---

The Elves responsible for water filtering operations took a snapshot of the bricks while they were still falling
(your puzzle input) which should let you work out which bricks are safe to disintegrate. For example:

1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9

Each line of text in the snapshot represents the position of a single brick at the time the snapshot was taken. The
position is given as two x,y,z coordinates - one for each end of the brick - separated by a tilde (~). Each brick
is made up of a single straight line of cubes, and the Elves were even careful to choose a time for the snapshot
that had all of the free-falling bricks at integer positions above the ground, so the whole snapshot is aligned to
a three-dimensional cube grid.

A line like 2,2,2~2,2,2 means that both ends of the brick are at the same coordinate - in other words, that the
brick is a single cube.

Lines like 0,0,10~1,0,10 or 0,0,10~0,1,10 both represent bricks that are two cubes in volume, both oriented
horizontally. The first brick extends in the x direction, while the second brick extends in the y direction.

A line like 0,0,1~0,0,10 represents a ten-cube brick which is oriented vertically. One end of the brick is the cube
located at 0,0,1, while the other end of the brick is located directly above it at 0,0,10.

The ground is at z=0 and is perfectly flat; the lowest z value a brick can have is therefore 1. So, 5,5,1~5,6,1 and
0,2,1~0,2,5 are both resting on the ground, but 3,3,2~3,3,3 was above the ground at the time of the snapshot.

Because the snapshot was taken while the bricks were still falling, some bricks will still be in the air; you'll
need to start by figuring out where they will end up. Bricks are magically stabilized, so they never rotate, even
in weird situations like where a long horizontal brick is only supported on one end. Two bricks cannot occupy the
same position, so a falling brick will come to rest upon the first other brick it encounters.

Here is the same example again, this time with each brick given a letter so it can be marked in diagrams:

1,0,1~1,2,1   <- A
0,0,2~2,0,2   <- B
0,2,3~2,2,3   <- C
0,0,4~0,2,4   <- D
2,0,5~2,2,5   <- E
0,1,6~2,1,6   <- F
1,1,8~1,1,9   <- G

At the time of the snapshot, from the side so the x axis goes left to right, these bricks are arranged like this:

 x
012
.G. 9
.G. 8
... 7
FFF 6
..E 5 z
D.. 4
CCC 3
BBB 2
.A. 1
--- 0

Rotating the perspective 90 degrees so the y axis now goes left to right, the same bricks are arranged like this:

 y
012
.G. 9
.G. 8
... 7
.F. 6
EEE 5 z
DDD 4
..C 3
B.. 2
AAA 1
--- 0

Once all of the bricks fall downward as far as they can go, the stack looks like this, where ? means bricks are
hidden behind other bricks at that location:

 x
012
.G. 6
.G. 5
FFF 4
D.E 3 z
??? 2
.A. 1
--- 0

Again from the side:

 y
012
.G. 6
.G. 5
.F. 4
??? 3 z
B.C 2
AAA 1
--- 0

Now that all of the bricks have settled, it becomes easier to tell which bricks are supporting which other bricks:

Brick A is the only brick supporting bricks B and C.
Brick B is one of two bricks supporting brick D and brick E.
Brick C is the other brick supporting brick D and brick E.
Brick D supports brick F.
Brick E also supports brick F.
Brick F supports brick G.
Brick G isn't supporting any bricks.

Your first task is to figure out which bricks are safe to disintegrate. A brick can be safely disintegrated if,
after removing it, no other bricks would fall further directly downward. Don't actually disintegrate any bricks -
just determine what would happen if, for each brick, only that brick were disintegrated. Bricks can be
disintegrated even if they're completely surrounded by other bricks; you can squeeze between bricks if you need to.

In this example, the bricks can be disintegrated as follows:

Brick A cannot be disintegrated safely; if it were disintegrated, bricks B and C would both fall.
Brick B can be disintegrated; the bricks above it (D and E) would still be supported by brick C.
Brick C can be disintegrated; the bricks above it (D and E) would still be supported by brick B.
Brick D can be disintegrated; the brick above it (F) would still be supported by brick E.
Brick E can be disintegrated; the brick above it (F) would still be supported by brick D.
Brick F cannot be disintegrated; the brick above it (G) would fall.
Brick G can be disintegrated; it does not support any other bricks.

So, in this example, 5 bricks can be safely disintegrated.

Figure how the blocks will settle based on the snapshot. Once they've settled, consider disintegrating a single
brick; how many bricks could be safely chosen as the one to get disintegrated?

--- Part Two ---

Disintegrating bricks one at a time isn't going to be fast enough. While it might sound dangerous, what you really
need is a chain reaction.

You'll need to figure out the best brick to disintegrate. For each brick, determine how many other bricks would
fall if that brick were disintegrated.

Using the same example as above:

  - Disintegrating brick A would cause all 6 other bricks to fall.
  - Disintegrating brick F would cause only 1 other brick, G, to fall.
  - Disintegrating any other brick would cause no other bricks to fall. So, in this example, the sum of the number
    of other bricks that would fall as a result of disintegrating each brick is 7.

For each brick, determine how many other bricks would fall if that brick were disintegrated. What is the sum of the
number of other bricks that would fall?

=end

require_relative '../util'

class SandSlabs
  def self.parse(text)
    new(text.lines(chomp: true).map { Brick.parse(_1) })
  end

  def initialize(bricks)
    @bricks = bricks
    @settled = []
    @by_position = {}
    settle_bricks
  end

  attr :bricks, :settled, :by_position

  Brick = Data.define(:pos1, :pos2) do
    def self.parse(text)
      new(*text.split('~').map { Position3D.parse(_1) })
    end

    def bottom_level = [pos1, pos2].map(&:z).min
    def drop = self.class[pos1.below, pos2.below]

    AXES = [:x, :y, :z]

    def range(axis)
      coord1, coord2 = pos1.send(axis), pos2.send(axis)
      coord1 < coord2 ? coord1..coord2 : coord2..coord1
    end

    def positions
      range(:z).flat_map { |z| range(:y).flat_map { |y| range(:x).map { |x| Position3D[x,y,z] } } }
    end
  end

  Position3D = Data.define(:x, :y, :z) do
    def self.parse(text)
      new(*text.split(',').map(&:to_i))
    end
    def above = with(z: z+1)
    def below = with(z: z-1)
  end

  def settle_bricks
    bricks.sort_by(&:bottom_level).each do |brick|
      until brick.bottom_level == 1
        new_brick = brick.drop
        break if new_brick.positions.any? { by_position.key?(_1) }
        brick = new_brick
      end
      settled << brick
      brick.positions.each { by_position[_1] = brick }
    end
  end

  def bricks_above(brick) = brick.positions.filter_map { by_position[_1.above] }.to_set - Set[brick]
  def bricks_below(brick) = brick.positions.filter_map { by_position[_1.below] }.to_set - Set[brick]

  def bricks_supported_by(bricks)
    above = bricks.map { bricks_above(_1) }.reduce(:union) - bricks
    above.filter { (bricks_below(_1) - bricks).empty? }
  end

  def disintegrateable_bricks = settled.filter { bricks_supported_by([_1]).empty? }
  def num_disintegrateable_bricks = disintegrateable_bricks.length

  def bricks_that_would_fall(supporting_bricks)
    # TODO: can this be made more efficient?
    supported = bricks_supported_by(supporting_bricks)
    return [] if supported.empty?
    supported + bricks_that_would_fall(supporting_bricks + supported)
  end

  def sum_other_bricks_that_would_fall
    (settled - disintegrateable_bricks).sum { bricks_that_would_fall([_1]).length }
  end
end

if defined? DATA
  input = DATA.read
  obj = SandSlabs.parse(input)
  puts obj.num_disintegrateable_bricks
  puts obj.sum_other_bricks_that_would_fall
end

__END__
4,2,5~6,2,5
5,8,104~5,9,104
2,0,278~4,0,278
4,5,292~4,8,292
3,5,226~4,5,226
2,5,49~5,5,49
3,3,124~3,5,124
2,3,99~2,5,99
0,3,286~2,3,286
8,1,27~8,3,27
7,5,210~9,5,210
5,2,233~7,2,233
4,4,161~4,7,161
6,1,54~8,1,54
0,4,149~1,4,149
3,3,54~3,5,54
0,1,290~3,1,290
2,7,34~5,7,34
4,1,134~5,1,134
8,9,175~9,9,175
9,2,89~9,5,89
7,5,209~7,7,209
0,3,95~0,6,95
2,5,128~5,5,128
7,5,107~7,8,107
7,6,73~9,6,73
7,6,149~7,6,151
3,1,131~6,1,131
6,9,110~6,9,110
1,6,210~1,8,210
3,3,224~3,5,224
0,8,218~0,8,220
9,1,148~9,1,150
3,8,189~4,8,189
3,1,203~5,1,203
3,3,176~3,4,176
6,7,259~7,7,259
6,8,105~7,8,105
7,3,182~8,3,182
7,4,2~9,4,2
1,1,237~1,5,237
2,6,7~5,6,7
8,1,144~9,1,144
3,8,99~5,8,99
5,5,101~5,6,101
5,3,82~5,6,82
8,6,25~8,6,27
4,7,67~5,7,67
4,3,158~6,3,158
7,5,281~7,6,281
7,5,92~9,5,92
4,4,226~7,4,226
0,7,56~1,7,56
1,1,17~3,1,17
1,2,131~3,2,131
6,4,160~9,4,160
4,7,85~4,7,86
9,6,130~9,6,133
4,6,3~4,6,5
8,0,43~8,0,45
4,2,126~6,2,126
6,1,139~6,4,139
1,7,273~2,7,273
3,1,198~5,1,198
8,4,48~8,6,48
1,7,30~1,7,30
0,0,246~0,2,246
2,0,25~2,1,25
8,3,232~8,5,232
5,5,7~8,5,7
5,2,264~5,2,266
2,3,249~4,3,249
9,3,111~9,5,111
9,7,282~9,9,282
4,7,231~4,9,231
7,0,122~9,0,122
2,2,185~2,4,185
5,7,17~7,7,17
0,3,58~1,3,58
0,2,131~0,5,131
9,6,11~9,8,11
9,7,277~9,9,277
3,9,79~5,9,79
4,2,245~6,2,245
1,2,254~1,4,254
5,7,225~5,9,225
2,1,39~3,1,39
2,0,252~2,3,252
5,8,302~5,9,302
7,4,121~9,4,121
1,1,98~1,2,98
7,6,58~9,6,58
3,3,98~3,6,98
3,0,236~3,2,236
8,6,284~8,8,284
4,6,163~4,8,163
6,2,25~7,2,25
1,5,230~1,5,232
7,8,3~7,9,3
6,2,197~8,2,197
2,0,101~2,2,101
0,0,62~1,0,62
3,0,262~3,3,262
5,2,201~5,2,203
3,2,2~3,4,2
7,4,3~7,6,3
8,2,23~8,4,23
3,6,201~3,7,201
1,7,279~1,9,279
7,0,121~8,0,121
9,0,32~9,0,34
5,8,75~5,8,77
6,5,79~6,5,81
4,4,55~6,4,55
1,5,265~4,5,265
0,2,84~2,2,84
6,0,84~6,2,84
5,0,135~7,0,135
1,8,254~3,8,254
7,6,202~7,9,202
4,9,241~5,9,241
0,2,124~1,2,124
2,7,127~2,7,128
4,3,137~4,7,137
7,0,221~7,1,221
7,5,94~7,5,98
3,1,93~6,1,93
7,5,279~7,7,279
1,3,64~2,3,64
4,5,245~4,7,245
7,3,46~7,6,46
1,6,254~3,6,254
0,6,38~2,6,38
5,5,273~7,5,273
2,2,133~4,2,133
0,9,123~0,9,126
0,2,125~0,2,127
2,1,135~2,3,135
6,1,147~9,1,147
4,9,8~4,9,9
1,6,190~4,6,190
6,5,176~7,5,176
4,1,29~6,1,29
4,3,239~4,5,239
1,2,57~1,5,57
8,9,3~9,9,3
0,3,209~0,6,209
2,0,27~4,0,27
3,9,174~5,9,174
5,0,59~5,2,59
8,5,18~8,8,18
1,0,209~3,0,209
7,5,47~9,5,47
9,3,101~9,4,101
0,7,16~0,8,16
6,6,125~9,6,125
6,1,18~6,3,18
7,8,214~8,8,214
9,6,169~9,8,169
4,6,119~4,9,119
4,2,223~4,2,224
2,2,34~5,2,34
0,5,50~0,5,52
4,7,11~6,7,11
1,7,277~3,7,277
3,6,125~3,8,125
9,1,268~9,3,268
8,1,186~8,1,189
3,2,230~6,2,230
1,4,196~4,4,196
9,6,289~9,8,289
4,1,207~5,1,207
0,4,1~2,4,1
2,6,90~2,8,90
8,1,185~8,3,185
9,7,241~9,8,241
2,2,247~5,2,247
5,2,273~5,3,273
2,7,223~2,9,223
0,6,111~2,6,111
3,8,101~3,9,101
0,0,1~0,1,1
3,1,271~3,4,271
6,6,227~8,6,227
8,3,237~9,3,237
0,7,22~0,8,22
4,7,242~6,7,242
9,2,265~9,3,265
8,3,269~8,4,269
2,5,258~2,7,258
0,7,128~1,7,128
8,1,71~9,1,71
5,3,307~7,3,307
1,3,152~1,5,152
6,6,89~6,8,89
4,2,285~7,2,285
2,0,284~2,3,284
1,8,156~2,8,156
0,4,3~1,4,3
8,1,75~8,1,77
9,1,80~9,4,80
1,4,85~5,4,85
4,8,185~4,8,186
2,5,89~4,5,89
6,9,80~6,9,81
5,2,257~5,6,257
0,4,157~0,6,157
4,0,201~4,3,201
1,5,227~2,5,227
1,8,260~3,8,260
7,6,70~7,8,70
7,7,2~9,7,2
4,4,15~4,4,17
4,5,220~6,5,220
0,8,115~2,8,115
1,9,282~1,9,282
6,4,8~6,5,8
5,5,261~5,7,261
7,1,275~7,4,275
0,7,293~0,8,293
0,1,287~2,1,287
2,5,198~2,8,198
6,6,197~6,8,197
3,5,6~4,5,6
6,1,272~8,1,272
9,4,19~9,6,19
5,0,34~7,0,34
5,7,94~5,8,94
2,6,234~2,6,236
5,5,213~7,5,213
2,2,305~2,5,305
1,3,148~3,3,148
1,4,267~1,7,267
0,7,27~0,8,27
1,6,24~4,6,24
3,6,81~3,8,81
5,4,180~5,6,180
2,4,139~5,4,139
6,5,82~6,5,84
6,6,186~6,8,186
4,1,199~6,1,199
8,0,275~8,1,275
4,6,60~7,6,60
6,3,196~6,5,196
0,5,156~1,5,156
4,5,169~4,6,169
6,1,132~6,4,132
4,5,302~4,5,302
7,3,136~8,3,136
1,1,16~2,1,16
5,1,140~6,1,140
4,1,206~6,1,206
4,8,223~6,8,223
9,3,112~9,5,112
9,4,237~9,7,237
7,6,266~7,9,266
2,2,181~2,5,181
0,7,11~0,9,11
9,1,226~9,1,226
1,5,147~4,5,147
2,2,97~2,5,97
1,3,109~1,7,109
1,0,270~3,0,270
9,5,91~9,8,91
0,3,45~0,5,45
2,1,280~2,4,280
7,2,123~7,5,123
2,1,167~2,5,167
2,1,10~2,1,11
0,0,38~3,0,38
7,5,132~8,5,132
6,2,42~6,3,42
1,0,196~2,0,196
9,1,225~9,2,225
0,9,92~0,9,92
4,2,220~4,4,220
2,7,172~2,9,172
4,5,51~4,5,53
6,5,46~6,5,48
2,8,293~4,8,293
6,1,270~9,1,270
2,5,207~5,5,207
8,7,287~8,7,287
7,1,41~8,1,41
7,8,129~9,8,129
5,8,15~8,8,15
0,6,223~1,6,223
4,6,28~4,8,28
5,5,254~5,7,254
0,0,65~0,0,67
5,5,183~5,5,186
4,9,256~7,9,256
0,2,123~0,4,123
7,0,29~9,0,29
1,6,218~1,8,218
3,9,6~5,9,6
6,3,67~9,3,67
3,5,250~3,7,250
7,0,38~7,0,38
0,6,122~0,7,122
6,7,269~8,7,269
3,9,91~4,9,91
3,3,171~5,3,171
9,0,91~9,2,91
2,1,246~4,1,246
5,0,252~5,2,252
3,5,268~3,5,269
2,5,15~2,9,15
7,0,120~7,3,120
7,2,212~7,4,212
7,0,8~7,2,8
0,2,248~0,3,248
0,9,86~1,9,86
3,8,85~6,8,85
7,6,181~9,6,181
3,5,246~3,7,246
3,2,82~3,5,82
5,8,280~9,8,280
5,4,159~5,6,159
3,0,204~5,0,204
9,2,76~9,4,76
8,6,122~8,8,122
5,0,161~5,1,161
7,3,35~7,5,35
2,9,74~4,9,74
7,8,50~9,8,50
5,6,92~5,8,92
8,4,4~9,4,4
3,7,87~4,7,87
0,9,120~2,9,120
8,7,128~8,9,128
8,2,20~9,2,20
9,7,77~9,8,77
3,0,183~4,0,183
3,0,269~6,0,269
1,2,231~1,4,231
0,6,6~0,8,6
2,4,272~3,4,272
6,4,175~6,7,175
1,2,202~2,2,202
4,9,121~6,9,121
5,4,158~7,4,158
7,8,215~7,8,218
0,4,128~0,6,128
5,6,51~7,6,51
2,8,23~2,8,23
4,9,96~6,9,96
3,2,9~3,5,9
6,7,92~9,7,92
2,8,34~3,8,34
0,4,19~0,7,19
4,8,64~7,8,64
4,3,203~7,3,203
9,5,127~9,6,127
3,6,229~3,7,229
2,3,275~2,5,275
7,5,40~7,5,43
5,3,133~7,3,133
5,8,19~7,8,19
8,5,56~9,5,56
2,3,34~2,6,34
6,2,119~7,2,119
0,4,8~0,6,8
5,4,80~8,4,80
6,3,99~8,3,99
6,5,303~8,5,303
2,7,75~4,7,75
9,1,83~9,5,83
3,2,253~3,4,253
8,4,214~8,5,214
3,4,277~5,4,277
3,5,27~3,6,27
2,0,116~2,0,117
6,7,275~9,7,275
0,4,29~2,4,29
7,9,205~7,9,207
5,1,217~7,1,217
0,7,31~1,7,31
3,4,251~6,4,251
1,8,118~3,8,118
3,1,89~6,1,89
4,8,287~6,8,287
9,4,100~9,7,100
1,3,276~1,4,276
1,2,199~3,2,199
1,3,228~1,5,228
8,5,213~8,6,213
0,0,103~2,0,103
1,6,89~1,8,89
4,5,131~4,6,131
1,1,61~1,3,61
3,0,83~3,2,83
4,5,215~6,5,215
3,2,250~5,2,250
3,3,11~5,3,11
7,1,50~7,4,50
7,5,10~9,5,10
3,2,254~3,5,254
4,6,98~4,6,100
5,2,118~7,2,118
0,4,90~0,7,90
2,5,86~2,6,86
8,0,9~8,3,9
8,3,116~9,3,116
1,4,36~1,6,36
0,1,208~0,1,208
9,6,283~9,9,283
5,3,68~7,3,68
2,4,121~2,5,121
1,8,263~3,8,263
9,5,118~9,7,118
1,2,238~1,3,238
6,4,140~8,4,140
1,1,94~1,1,96
2,1,37~4,1,37
6,2,24~8,2,24
1,1,151~1,1,152
6,0,142~8,0,142
0,2,17~0,4,17
4,2,112~4,5,112
5,6,67~7,6,67
4,0,167~5,0,167
0,6,118~2,6,118
5,7,250~5,9,250
6,4,56~6,6,56
4,7,263~4,9,263
1,4,92~1,7,92
0,9,82~3,9,82
8,1,194~8,4,194
9,5,98~9,8,98
6,7,74~8,7,74
9,7,238~9,9,238
8,7,78~8,7,78
8,4,104~9,4,104
9,5,93~9,6,93
4,7,31~5,7,31
8,1,109~8,3,109
0,9,89~0,9,89
4,0,224~6,0,224
5,0,96~7,0,96
0,6,159~0,6,161
0,4,158~0,4,160
2,8,286~4,8,286
7,7,6~7,9,6
2,3,248~2,4,248
0,5,163~0,7,163
0,4,38~1,4,38
1,3,107~1,6,107
3,6,243~5,6,243
1,6,54~2,6,54
6,3,69~7,3,69
1,0,1~3,0,1
4,3,213~7,3,213
5,8,7~8,8,7
6,9,91~7,9,91
0,5,203~2,5,203
4,3,176~6,3,176
5,9,226~7,9,226
6,2,134~6,2,136
9,5,121~9,7,121
4,2,110~4,5,110
1,3,83~3,3,83
7,2,9~7,2,11
8,0,181~8,3,181
0,4,89~0,7,89
9,4,222~9,5,222
0,1,94~0,1,96
1,0,235~1,4,235
4,8,51~7,8,51
3,1,104~3,4,104
3,4,147~3,4,149
3,3,107~6,3,107
6,3,261~8,3,261
8,0,237~8,2,237
8,5,74~8,5,77
2,8,174~4,8,174
0,3,232~0,5,232
6,7,158~8,7,158
5,1,159~5,3,159
4,3,221~5,3,221
4,6,289~6,6,289
7,6,176~7,8,176
0,5,204~2,5,204
7,5,101~8,5,101
1,4,27~1,7,27
3,5,166~3,8,166
2,4,39~3,4,39
6,0,182~7,0,182
9,1,223~9,4,223
6,3,290~7,3,290
0,5,48~0,7,48
6,2,89~6,2,89
5,4,31~7,4,31
6,5,281~6,6,281
4,6,164~7,6,164
0,0,40~2,0,40
0,4,80~1,4,80
8,2,292~8,5,292
0,4,12~3,4,12
3,2,53~3,4,53
2,3,153~5,3,153
1,8,221~4,8,221
9,8,1~9,8,2
3,3,304~5,3,304
0,1,200~4,1,200
4,0,109~7,0,109
0,3,47~0,5,47
5,1,289~8,1,289
4,2,113~6,2,113
2,3,283~2,6,283
5,7,265~5,9,265
0,3,195~0,4,195
5,5,230~5,5,232
5,7,247~5,9,247
6,9,14~8,9,14
5,6,182~5,8,182
6,6,14~8,6,14
6,4,255~6,7,255
1,1,92~1,2,92
4,4,294~6,4,294
7,7,214~7,7,215
8,1,239~8,1,240
1,1,25~1,3,25
7,2,213~7,2,213
5,1,197~8,1,197
1,6,200~3,6,200
7,9,105~9,9,105
2,3,237~4,3,237
3,4,145~5,4,145
0,5,112~0,8,112
6,1,291~7,1,291
3,5,301~6,5,301
2,7,115~4,7,115
1,5,153~4,5,153
6,1,23~6,4,23
2,7,130~2,9,130
1,8,120~3,8,120
5,4,106~6,4,106
0,2,183~2,2,183
8,3,94~8,3,96
6,6,278~9,6,278
3,3,50~5,3,50
7,7,72~7,9,72
3,3,216~5,3,216
4,7,278~6,7,278
1,4,79~4,4,79
8,0,205~8,2,205
0,3,134~0,3,135
5,6,93~6,6,93
5,7,277~6,7,277
5,1,53~7,1,53
2,6,140~4,6,140
7,1,284~7,3,284
0,2,91~1,2,91
2,4,44~2,4,44
7,7,290~8,7,290
0,9,260~2,9,260
6,1,74~8,1,74
3,1,222~3,3,222
2,3,41~2,4,41
4,9,124~6,9,124
4,8,299~7,8,299
0,3,122~2,3,122
1,4,58~3,4,58
3,3,219~5,3,219
2,8,79~4,8,79
5,4,37~7,4,37
1,0,194~2,0,194
2,1,7~2,4,7
2,5,263~4,5,263
7,2,287~7,4,287
9,9,36~9,9,36
1,7,85~1,9,85
3,2,261~5,2,261
2,9,32~4,9,32
1,8,46~1,8,48
4,5,72~4,8,72
7,0,26~8,0,26
7,2,207~9,2,207
3,9,36~5,9,36
8,7,19~8,8,19
8,3,263~9,3,263
2,3,66~4,3,66
3,1,118~3,2,118
7,1,38~7,1,39
2,1,206~2,4,206
1,6,145~1,7,145
8,6,51~9,6,51
9,5,4~9,7,4
3,6,158~7,6,158
6,4,6~7,4,6
4,6,52~4,9,52
8,2,212~8,4,212
3,4,159~3,5,159
0,8,91~1,8,91
1,4,251~2,4,251
2,6,249~5,6,249
4,5,267~4,6,267
5,6,168~5,9,168
2,1,268~4,1,268
2,1,166~5,1,166
1,7,236~1,9,236
2,6,95~4,6,95
3,8,283~5,8,283
6,3,217~6,5,217
3,2,208~4,2,208
7,4,71~9,4,71
7,1,264~7,3,264
3,4,63~3,5,63
2,9,69~5,9,69
4,6,133~4,6,135
9,1,220~9,3,220
2,4,276~3,4,276
8,3,266~8,5,266
3,1,169~3,3,169
6,8,29~6,9,29
0,0,25~0,3,25
4,9,251~6,9,251
1,4,234~3,4,234
6,5,17~6,6,17
1,4,113~1,7,113
2,1,272~4,1,272
7,6,102~9,6,102
7,3,220~7,4,220
1,9,216~4,9,216
8,0,101~8,3,101
2,2,56~2,3,56
3,6,35~4,6,35
0,4,229~3,4,229
7,2,7~9,2,7
0,3,273~4,3,273
6,8,178~8,8,178
2,3,127~2,3,130
8,0,295~8,2,295
6,4,61~6,4,62
7,5,272~7,8,272
0,6,3~2,6,3
2,6,157~2,9,157
4,3,230~4,3,233
1,2,260~1,3,260
2,8,74~5,8,74
4,5,271~4,6,271
4,4,262~5,4,262
5,1,22~8,1,22
3,5,155~5,5,155
7,0,134~7,3,134
5,2,22~5,2,22
1,1,203~1,3,203
7,6,277~7,9,277
9,1,228~9,2,228
7,2,73~8,2,73
9,0,75~9,3,75
1,5,157~1,5,157
4,2,13~4,4,13
8,6,22~8,8,22
1,1,64~4,1,64
2,0,192~4,0,192
0,6,126~2,6,126
1,2,146~1,4,146
6,7,101~7,7,101
2,9,134~3,9,134
1,8,22~4,8,22
3,3,110~3,6,110
0,5,93~1,5,93
9,6,18~9,8,18
5,5,158~8,5,158
8,7,155~9,7,155
4,3,260~7,3,260
0,2,251~0,2,253
6,5,4~6,8,4
0,3,276~0,6,276
8,4,198~8,5,198
0,7,117~0,9,117
8,0,238~8,0,240
0,3,182~3,3,182
1,6,159~1,9,159
2,3,156~4,3,156
6,3,178~8,3,178
4,7,185~7,7,185
1,6,238~1,8,238
0,8,8~3,8,8
9,2,94~9,2,95
3,0,115~3,2,115
6,9,34~9,9,34
5,4,88~8,4,88
2,3,229~4,3,229
9,3,106~9,5,106
6,2,219~6,4,219
3,1,1~3,1,3
7,4,268~9,4,268
5,8,28~6,8,28
6,1,273~8,1,273
5,9,16~7,9,16
9,3,209~9,6,209
5,7,297~7,7,297
0,8,216~2,8,216
2,0,240~2,2,240
0,2,286~3,2,286
6,2,45~6,5,45
5,4,98~5,6,98
1,0,248~1,0,251
2,7,69~4,7,69
9,2,3~9,3,3
0,6,208~2,6,208
5,7,86~5,9,86
7,0,209~7,3,209
8,6,270~8,7,270
1,3,301~4,3,301
1,2,54~3,2,54
4,0,181~6,0,181
0,7,199~2,7,199
5,8,103~7,8,103
1,0,207~1,2,207
6,1,15~8,1,15
2,5,231~2,7,231
2,5,155~2,8,155
8,3,118~8,3,119
4,9,239~7,9,239
1,2,88~1,3,88
9,2,269~9,4,269
1,1,65~1,1,67
4,8,25~5,8,25
6,2,79~8,2,79
8,6,127~8,8,127
5,0,2~6,0,2
7,7,23~8,7,23
5,0,162~5,2,162
1,0,147~1,2,147
3,9,176~6,9,176
6,9,31~8,9,31
6,4,199~6,4,199
3,4,24~6,4,24
2,8,9~4,8,9
1,6,1~2,6,1
4,2,203~4,2,206
3,1,113~3,3,113
5,7,88~5,7,88
5,1,94~5,2,94
4,2,7~5,2,7
4,3,92~4,6,92
2,0,100~2,3,100
8,6,63~8,7,63
6,8,80~7,8,80
6,5,2~9,5,2
2,1,257~2,3,257
7,5,72~8,5,72
4,0,98~4,0,100
3,7,224~5,7,224
3,5,30~5,5,30
2,5,100~4,5,100
3,2,277~5,2,277
0,8,53~0,9,53
6,1,90~8,1,90
3,7,100~3,8,100
3,8,33~3,9,33
6,9,258~6,9,262
3,5,272~3,5,272
7,0,210~9,0,210
1,6,205~1,8,205
2,7,48~2,7,51
2,2,259~2,4,259
5,7,59~8,7,59
1,4,143~1,6,143
8,6,273~8,7,273
1,9,132~3,9,132
2,8,33~2,9,33
2,7,228~2,8,228
3,5,3~5,5,3
2,7,77~2,9,77
8,2,211~9,2,211
8,4,168~8,6,168
2,7,110~2,7,112
7,5,115~9,5,115
6,1,128~7,1,128
9,2,55~9,5,55
9,5,223~9,8,223
6,3,2~6,3,5
0,7,54~0,8,54
1,5,274~1,5,276
3,0,5~5,0,5
9,3,93~9,3,93
5,5,150~5,8,150
2,3,151~5,3,151
4,3,57~4,4,57
4,7,189~4,7,192
6,1,7~8,1,7
7,6,211~7,8,211
2,6,209~4,6,209
2,1,40~2,1,43
5,4,27~7,4,27
1,2,20~1,3,20
3,6,227~3,7,227
6,5,172~8,5,172
4,5,8~4,6,8
8,1,214~8,3,214
3,2,37~3,4,37
7,1,25~9,1,25
5,2,223~5,4,223
4,4,179~4,4,181
4,3,278~4,5,278
4,8,184~6,8,184
0,4,115~0,6,115
6,0,94~8,0,94
7,0,141~8,0,141
4,9,122~5,9,122
3,3,242~5,3,242
8,7,237~8,9,237
2,4,102~4,4,102
8,3,60~8,6,60
2,1,168~2,1,170
8,0,89~8,0,92
6,5,190~6,5,192
7,5,119~9,5,119
6,5,77~6,8,77
0,1,14~0,1,15
7,6,48~7,8,48
0,8,13~2,8,13
8,4,288~8,7,288
0,1,271~2,1,271
4,9,278~7,9,278
2,6,301~5,6,301
2,4,107~2,7,107
4,4,254~7,4,254
1,0,24~4,0,24
1,1,244~3,1,244
0,4,54~0,6,54
7,3,104~8,3,104
1,8,229~1,9,229
4,9,7~5,9,7
3,6,288~3,8,288
9,7,286~9,9,286
5,3,49~7,3,49
4,1,167~4,4,167
0,8,50~2,8,50
1,6,25~1,9,25
5,5,244~5,7,244
8,3,170~8,5,170
8,3,12~8,5,12
5,8,200~7,8,200
6,7,258~8,7,258
2,2,110~2,5,110
2,7,233~2,9,233
6,1,87~6,4,87
2,2,4~4,2,4
2,0,45~4,0,45
8,5,276~8,8,276
7,1,201~8,1,201
4,0,95~6,0,95
5,1,55~5,2,55
7,6,6~7,6,9
4,7,66~4,9,66
1,7,255~3,7,255
0,7,274~3,7,274
2,4,243~4,4,243
0,0,42~3,0,42
1,3,200~3,3,200
0,0,95~1,0,95
3,8,151~5,8,151
4,2,140~4,4,140
1,7,116~1,9,116
7,5,215~9,5,215
0,1,13~0,4,13
8,4,116~9,4,116
2,0,302~2,3,302
5,1,156~5,4,156
7,7,293~7,7,295
3,0,288~3,2,288
8,8,130~9,8,130
1,1,263~3,1,263
9,3,74~9,5,74
1,1,18~1,1,20
3,7,11~3,9,11
3,1,223~5,1,223
5,4,74~7,4,74
6,3,39~6,5,39
0,1,133~0,3,133
6,7,100~7,7,100
6,8,234~9,8,234
1,8,53~3,8,53
5,0,133~5,2,133
4,1,26~6,1,26
7,6,10~9,6,10
5,2,21~5,4,21
0,2,81~0,5,81
2,7,8~4,7,8
5,7,264~8,7,264
6,0,25~6,0,28
5,6,178~7,6,178
1,0,68~3,0,68
6,3,58~6,5,58
3,9,178~6,9,178
8,3,169~8,5,169
2,7,96~2,9,96
0,3,186~2,3,186
4,6,96~6,6,96
6,5,188~6,7,188
4,0,168~4,1,168
8,7,106~9,7,106
9,8,237~9,9,237
5,0,164~5,3,164
0,6,25~0,8,25
3,3,204~5,3,204
0,5,190~3,5,190
8,3,230~8,6,230
5,0,287~5,2,287
4,4,260~4,7,260
8,5,130~9,5,130
4,9,93~4,9,95
6,9,254~9,9,254
4,2,263~6,2,263
2,2,226~4,2,226
5,8,285~7,8,285
7,4,214~7,4,217
3,7,124~5,7,124
0,0,245~4,0,245
7,4,196~8,4,196
2,7,74~4,7,74
2,5,2~3,5,2
1,2,163~1,4,163
1,6,82~3,6,82
0,0,4~0,1,4
2,4,124~2,7,124
8,0,18~8,2,18
3,2,298~3,5,298
6,4,195~6,5,195
1,2,165~1,3,165
6,8,281~7,8,281
5,3,1~7,3,1
5,9,172~8,9,172
6,8,67~8,8,67
8,1,290~9,1,290
5,7,245~7,7,245
5,7,7~7,7,7
5,4,81~6,4,81
0,7,232~2,7,232
5,1,12~8,1,12
1,6,5~3,6,5
5,7,299~8,7,299
4,8,233~6,8,233
7,9,21~8,9,21
2,0,113~2,2,113
3,1,234~5,1,234
3,3,123~6,3,123
1,7,45~1,8,45
5,5,15~8,5,15
0,7,175~3,7,175
3,5,266~3,7,266
6,6,90~6,8,90
7,3,206~7,5,206
5,6,118~6,6,118
5,8,96~6,8,96
5,9,87~8,9,87
0,3,42~0,5,42
0,7,34~0,9,34
1,3,227~3,3,227
6,3,75~8,3,75
1,1,14~3,1,14
8,6,103~8,8,103
5,4,258~8,4,258
4,3,19~7,3,19
6,9,279~6,9,281
8,1,110~9,1,110
6,4,229~6,4,232
1,2,85~1,2,85
4,2,147~4,4,147
9,8,100~9,9,100
4,0,40~4,1,40
9,2,216~9,6,216
8,4,289~9,4,289
3,1,119~3,2,119
2,4,246~4,4,246
3,1,202~5,1,202
2,5,94~4,5,94
3,0,12~3,3,12
2,0,239~2,3,239
4,2,251~4,2,253
7,3,139~9,3,139
1,4,120~4,4,120
3,8,164~5,8,164
0,5,9~0,5,11
6,0,237~6,2,237
5,1,44~7,1,44
3,4,117~3,4,117
2,5,293~2,7,293
7,4,53~7,5,53
5,6,122~7,6,122
7,9,35~8,9,35
3,9,78~6,9,78
1,4,62~3,4,62
5,1,169~7,1,169
1,2,11~1,5,11
4,0,21~4,2,21
0,1,209~2,1,209
1,2,64~3,2,64
1,1,266~2,1,266
7,0,99~7,1,99
4,8,17~7,8,17
0,0,92~0,2,92
5,6,62~5,9,62
4,6,262~4,7,262
2,3,155~4,3,155
4,5,164~6,5,164
3,2,197~3,4,197
2,5,55~4,5,55
5,0,23~8,0,23
3,5,58~5,5,58
3,5,117~4,5,117
4,7,140~6,7,140
2,0,277~2,3,277
7,3,91~9,3,91
9,4,3~9,7,3
6,0,20~6,2,20
8,2,104~8,2,106
7,6,119~8,6,119
2,3,201~2,3,202
4,7,120~4,7,122
8,4,81~8,6,81
5,1,215~8,1,215
1,6,26~1,9,26
7,4,173~7,6,173
9,3,119~9,3,121
5,3,237~5,6,237
6,1,220~8,1,220
7,4,219~7,6,219
4,5,250~4,7,250
9,8,13~9,8,15
7,3,282~7,5,282
7,3,56~7,7,56
3,5,126~5,5,126
4,0,22~6,0,22
1,4,83~1,5,83
6,6,165~8,6,165
4,1,146~4,4,146
3,2,129~3,4,129
1,4,44~1,7,44
5,9,1~8,9,1
4,9,285~7,9,285
4,8,165~6,8,165
1,5,60~1,5,62
1,4,204~4,4,204
7,7,62~9,7,62
0,1,136~0,1,137
1,1,148~3,1,148
4,7,296~4,9,296
8,0,42~8,3,42
3,9,13~3,9,14
2,9,218~5,9,218
2,4,93~2,7,93
4,6,258~7,6,258
6,8,167~9,8,167
9,4,95~9,7,95
0,9,250~2,9,250
5,6,228~5,8,228
4,5,187~4,7,187
1,4,142~3,4,142
9,7,284~9,8,284
5,5,91~5,7,91
6,0,236~6,3,236
3,8,169~3,8,169
4,5,241~4,7,241
4,0,15~4,2,15
3,3,60~3,5,60
8,0,191~8,2,191
8,1,204~8,2,204
0,9,245~2,9,245
9,4,1~9,6,1
9,4,219~9,7,219
5,9,281~5,9,283
4,6,229~6,6,229
3,5,160~3,9,160
4,0,18~6,0,18
5,1,168~5,1,168
3,3,174~5,3,174
3,0,266~3,4,266
1,6,115~5,6,115
6,8,109~6,9,109
8,3,285~8,5,285
5,7,153~8,7,153
3,9,93~3,9,95
0,6,247~0,9,247
2,7,3~2,8,3
1,9,29~2,9,29
0,1,194~0,3,194
4,0,103~4,1,103
3,4,144~3,6,144
4,2,241~4,4,241
2,6,21~4,6,21
1,0,279~3,0,279
6,1,2~7,1,2
3,7,226~4,7,226
8,5,69~8,8,69
5,9,3~6,9,3
1,4,46~1,6,46
0,8,235~2,8,235
1,0,64~1,0,65
9,1,109~9,4,109
2,5,248~4,5,248
6,5,291~8,5,291
6,5,87~6,7,87
6,5,154~6,5,156
3,6,252~3,8,252
6,3,141~6,5,141
6,1,125~6,3,125
8,1,223~8,2,223
4,4,269~4,7,269
1,2,9~1,4,9
1,2,153~2,2,153
4,5,166~4,7,166
0,5,166~0,5,167
2,1,173~4,1,173
0,1,22~2,1,22
5,0,99~6,0,99
3,4,188~3,6,188
0,3,120~0,6,120
6,0,36~8,0,36
5,0,57~5,3,57
0,7,291~3,7,291
8,3,1~8,3,3
4,6,31~4,6,33
4,4,116~4,6,116
9,2,114~9,5,114
1,4,105~3,4,105
2,7,125~2,9,125
2,5,83~2,7,83
1,4,202~1,6,202
6,3,28~6,5,28
4,6,196~7,6,196
4,4,248~6,4,248
2,4,178~4,4,178
6,7,24~8,7,24
0,7,21~0,9,21
7,7,13~7,9,13
5,2,120~5,3,120
0,6,42~3,6,42
1,1,255~4,1,255
4,6,305~4,8,305
3,4,157~3,6,157
6,6,143~6,7,143
0,4,150~1,4,150
1,3,90~1,4,90
1,7,257~1,9,257
2,1,36~2,2,36
9,0,99~9,2,99
5,1,97~6,1,97
6,2,227~6,4,227
5,2,260~7,2,260
2,4,186~4,4,186
2,6,2~2,9,2
7,3,228~7,5,228
8,7,216~8,9,216
2,5,53~2,7,53
8,1,200~8,3,200
2,5,87~2,8,87
4,9,72~6,9,72
0,2,274~3,2,274
4,6,171~4,6,173
1,7,215~1,9,215
2,3,179~2,5,179
6,6,151~6,7,151
8,5,173~9,5,173
8,0,104~8,0,104
2,6,295~2,6,298
9,8,108~9,9,108
8,2,44~8,2,47
5,0,36~5,3,36
0,2,289~0,4,289
3,4,296~4,4,296
1,2,257~1,5,257
6,2,81~8,2,81
0,0,191~2,0,191
5,7,98~7,7,98
2,3,126~4,3,126
7,2,65~7,4,65
5,2,43~5,2,44
2,7,5~4,7,5
9,2,86~9,3,86
9,1,219~9,2,219
6,0,86~8,0,86
5,5,37~7,5,37
3,4,225~5,4,225
0,1,39~0,4,39
7,4,234~9,4,234
4,7,229~4,8,229
1,1,291~1,1,293
8,5,283~8,8,283
6,6,145~6,8,145
5,2,38~5,2,41
4,4,77~5,4,77
0,0,27~0,0,27
1,7,221~3,7,221
4,0,221~4,2,221
5,7,14~5,7,16
3,7,152~5,7,152
1,0,28~2,0,28
0,1,40~0,1,42
3,7,248~3,9,248
5,3,245~7,3,245
6,3,137~6,5,137
8,1,112~8,1,113
3,5,12~3,7,12
5,8,254~7,8,254
3,5,225~6,5,225
5,2,269~5,3,269
9,1,70~9,4,70
2,6,18~2,8,18
2,0,188~2,2,188
2,9,242~5,9,242
4,2,86~7,2,86
4,2,271~7,2,271
8,2,11~8,2,11
1,0,37~3,0,37
0,7,125~0,8,125
1,3,271~1,5,271
4,7,95~6,7,95
8,1,96~9,1,96
3,0,121~3,1,121
5,1,35~8,1,35
3,3,116~3,5,116
2,7,11~2,9,11
6,0,180~6,3,180
4,3,85~6,3,85
4,8,236~4,9,236
7,7,76~9,7,76
5,6,292~5,8,292
4,2,115~6,2,115
4,5,82~4,8,82
6,2,72~9,2,72
6,3,71~6,3,72
1,8,20~3,8,20
9,1,92~9,1,95
9,0,8~9,2,8
1,2,17~1,5,17
0,7,201~0,8,201
2,0,242~2,1,242
6,3,136~6,5,136
4,1,35~4,4,35
2,6,43~2,6,45
2,5,225~2,7,225
6,0,271~8,0,271
8,0,206~8,0,208
2,7,6~5,7,6
8,2,235~8,4,235
4,3,160~4,3,163
2,9,170~5,9,170
7,9,290~9,9,290
6,0,274~6,0,276
3,5,13~4,5,13
6,9,18~8,9,18
4,6,142~4,8,142
4,8,204~7,8,204
1,6,57~3,6,57
1,5,87~1,7,87
8,4,118~8,7,118
1,4,161~3,4,161
6,8,107~6,8,108
7,7,51~9,7,51
6,6,286~8,6,286
0,9,3~0,9,5
7,4,64~7,7,64
0,3,14~2,3,14
4,6,37~7,6,37
3,0,133~3,1,133
7,4,199~7,6,199
7,8,71~9,8,71
6,0,107~8,0,107
8,2,78~9,2,78
0,0,192~0,2,192
2,6,29~3,6,29
2,2,14~3,2,14
6,5,150~6,6,150
4,6,89~4,8,89
4,3,181~6,3,181
1,6,41~2,6,41
3,6,302~5,6,302
4,2,243~5,2,243
4,9,90~6,9,90
3,6,256~3,8,256
0,3,125~0,5,125
8,0,6~8,3,6
3,0,35~5,0,35
1,3,270~1,7,270
5,4,105~5,5,105
4,5,33~7,5,33
3,6,203~5,6,203
5,5,170~5,6,170
1,8,102~4,8,102
7,4,257~9,4,257
4,7,195~6,7,195
8,4,143~9,4,143
7,0,138~7,0,138
1,7,278~3,7,278
4,1,106~4,1,109
5,4,199~5,5,199
4,0,169~5,0,169
7,1,144~7,1,146
1,2,205~1,4,205
6,1,141~8,1,141
2,5,46~2,7,46
9,1,208~9,4,208
8,5,1~8,7,1
4,4,104~5,4,104
4,2,170~4,4,170
1,8,213~2,8,213
0,4,30~0,6,30
0,9,226~2,9,226
0,1,205~2,1,205
5,2,199~7,2,199
5,7,252~5,8,252
9,7,287~9,9,287
1,5,33~3,5,33
0,2,150~1,2,150
5,9,73~5,9,76
5,1,279~5,3,279
1,0,60~1,2,60
8,6,13~8,8,13
6,1,86~8,1,86
5,1,32~5,3,32
8,9,103~9,9,103
9,7,158~9,7,160
6,7,226~6,8,226
4,4,193~4,6,193
1,4,6~3,4,6
3,0,232~3,2,232
4,4,293~4,7,293
5,8,100~7,8,100
1,5,220~1,7,220
0,7,292~3,7,292
4,3,235~5,3,235
0,1,86~0,4,86
5,0,122~5,2,122
5,3,229~5,5,229
6,6,225~6,8,225
2,0,123~4,0,123
9,1,152~9,1,155
3,8,294~3,8,296
5,8,10~7,8,10
3,2,136~3,2,136
7,9,37~7,9,37
6,9,73~6,9,77
5,4,52~9,4,52
7,0,31~8,0,31
6,5,153~6,5,153
1,5,116~1,5,118
1,5,196~5,5,196
5,6,148~8,6,148
8,0,83~8,2,83
5,5,10~5,5,10
