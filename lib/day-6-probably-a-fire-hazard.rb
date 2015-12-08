=begin

--- Day 6: Probably a Fire Hazard ---

Because your neighbors keep defeating you in the holiday house decorating contest year after year, you've decided
to deploy one million lights in a 1000x1000 grid.

Furthermore, because you've been especially nice this year, Santa has mailed you instructions on how to display the
ideal lighting configuration.

Lights in your grid are numbered from 0 to 999 in each direction; the lights at each corner are at 0,0, 0,999,
999,999, and 999,0. The instructions include whether to turn on, turn off, or toggle various inclusive ranges given
as coordinate pairs. Each coordinate pair represents opposite corners of a rectangle, inclusive; a coordinate pair
like 0,0 through 2,2 therefore refers to 9 lights in a 3x3 square. The lights all start turned off.

To defeat your neighbors this year, all you have to do is set up your lights by doing the instructions Santa sent
you in order.

For example:

 - turn on 0,0 through 999,999 would turn on (or leave on) every light.
 - toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and
   turning on the ones that were off.
 - turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.

After following the instructions, how many lights are lit?

=end

class Lights
  def initialize
    @lit = Array.new(1000) { Array.new(1000) }
  end

  def num_lit
    @lit.flatten.count { |l| l }
  end

  def do_instruction(instr)
    return unless instr.match /^(.+) (\d+),(\d+) through (\d+),(\d+)$/
    for row in $3.to_i .. $5.to_i do
      for col in $2.to_i .. $4.to_i do
        case $1
        when 'turn on'
          @lit[row][col] = true
        when 'toggle'
          @lit[row][col] = !@lit[row][col]
        when 'turn off'
          @lit[row][col] = false
        end
      end
    end
    self
  end

  def do_instructions(instrs)
    instrs.split("\n").each &method(:do_instruction)
    self
  end
end
