=begin

--- Day 23: Opening the Turing Lock ---

Little Jane Marie just got her very first computer for Christmas from some unknown benefactor. It comes with
instructions and an example program, but the computer itself seems to be malfunctioning. She's curious what the
program does, and would like you to help her run it.

The manual explains that the computer supports two registers and six instructions (truly, it goes on to remind the
reader, a state-of-the-art technology). The registers are named a and b, can hold any non-negative integer, and
begin with a value of 0. The instructions are as follows:

 - hlf r sets register r to half its current value, then continues with the next instruction.
 - tpl r sets register r to triple its current value, then continues with the next instruction.
 - inc r increments register r, adding 1 to it, then continues with the next instruction.
 - jmp offset is a jump; it continues with the instruction offset away relative to itself.
 - jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
 - jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).

All three jump instructions work with an offset relative to that instruction. The offset is always written with a
prefix + or - to indicate the direction of the jump (forward or backward, respectively). For example, jmp +1 would
simply continue with the next instruction, while jmp +0 would continuously jump back to itself forever.

The program exits when it tries to run an instruction beyond the ones defined.

For example, this program sets a to 2, because the jio instruction causes it to skip the tpl instruction:

inc a
jio a, +2
tpl a
inc a

What is the value in register b when the program in your puzzle input is finished executing?

--- Part Two ---

The unknown benefactor is very thankful for releasi-- er, helping little Jane Marie with her computer. Definitely
not to distract you, what is the value in register b after the program is finished executing if register a starts
as 1 instead?

=end

require 'logger'
require_relative 'util'

class Computer
  def initialize(debug = false)
    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO unless debug
  end

  def run_program(input, a = 0)
    instrs = input.split("\n")
    t = 0
    pc = 0
    reg = { 'a' => a, 'b' => 0 }
    while pc.in?(0...instrs.length)
      @log.debug "reg = #{reg}"
      instr = instrs[pc]
      @log.debug "pc = #{pc}, instr = #{instr.inspect}"
      offset = 1
      case instr
      when /hlf (.)/
        reg[$1] /= 2
      when /tpl (.)/
        reg[$1] *= 3
      when /inc (.)/
        reg[$1] += 1
      when /jmp ([+-]\d+)/
        offset = $1.to_i
      when /jie (.), ([+-]\d+)/
        offset = $2.to_i if reg[$1] % 2 == 0
      when /jio (.), ([+-]\d+)/
        offset = $2.to_i if reg[$1] == 1
      else
        raise "Illegal instruction: #{instr}"
      end
      pc += offset
      t += 1
    end
    reg
  end
end

if defined? DATA
  computer = Computer.new
  input = DATA.read
  puts computer.run_program(input)['b']
  puts computer.run_program(input, 1)['b']
end

__END__
jio a, +19
inc a
tpl a
inc a
tpl a
inc a
tpl a
tpl a
inc a
inc a
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
jmp +23
tpl a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
inc a
tpl a
inc a
tpl a
inc a
tpl a
inc a
inc a
tpl a
inc a
inc a
tpl a
tpl a
inc a
jio a, +8
inc b
jie a, +4
tpl a
inc a
jmp +2
hlf a
jmp -7
