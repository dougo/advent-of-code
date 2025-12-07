require 'logger'
require_relative '../util'

def run_program(input, **opts)
  Computer.new(*input.split("\n"), **opts).run
end

class Computer
  def initialize(*instrs, a: 0, b: 0, pc: 0, debug: false)
    @log = Logger.new(STDOUT)
    @log.level = Logger::INFO unless debug
    @instrs = instrs
    @reg = { 'a' => a, 'b' => b }
    @pc = pc
  end

  attr_reader :pc

  def [](reg)
    @reg[reg]
  end

  def run
    step while @pc.in?(0...@instrs.length)
    self
  end

  def step
    @log.debug "reg = #{@reg}"
    instr = @instrs[@pc]
    @log.debug "pc = #{@pc}, instr = #{instr.inspect}"
    offset = 1
    case instr
    when /hlf (.)/
      @reg[$1] /= 2
    when /tpl (.)/
      @reg[$1] *= 3
    when /inc (.)/
      @reg[$1] += 1
    when /jmp ([+-]\d+)/
      offset = $1.to_i
    when /jie (.), ([+-]\d+)/
      offset = $2.to_i if @reg[$1] % 2 == 0
    when /jio (.), ([+-]\d+)/
      offset = $2.to_i if @reg[$1] == 1
    else
      raise "Illegal instruction: #{instr}"
    end
    @pc += offset
    self
  end
end

if defined? DATA
  input = DATA.read
  puts run_program(input)['b']
  puts run_program(input, a: 1)['b']
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
