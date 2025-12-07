require_relative '../util'

class NoTimeForATaxicab
  def self.parse(text)
    new(text.chomp.split(', ').map { Instruction.parse(_1) })
  end

  def initialize(instructions)
    @instructions = instructions
  end

  attr :instructions

  Instruction = Data.define(:turn, :distance) do
    def self.parse(text)
      new(text[0], text[1..].to_i)
    end
  end

  def blocks_away
    pos = Position[0,0]
    dir = NORTH
    instructions.each do |instr|
      delta = 'L R'.index(instr.turn) - 1
      dir = dir.turn(delta)
      pos = pos.move(dir, instr.distance)
    end
    pos.row.abs + pos.col.abs
  end
end

if defined? DATA
  input = DATA.read
  obj = NoTimeForATaxicab.parse(input)
  puts obj.blocks_away
end

__END__
L4, R2, R4, L5, L3, L1, R4, R5, R1, R3, L3, L2, L2, R5, R1, L1, L2, R2, R2, L5, R5, R5, L2, R1, R2, L2, L4, L1, R5, R2, R1, R1, L2, L3, R2, L5, L186, L5, L3, R3, L5, R4, R2, L5, R1, R4, L1, L3, R3, R1, L1, R4, R2, L1, L4, R5, L1, R50, L4, R3, R78, R4, R2, L4, R3, L4, R4, L1, R5, L4, R1, L2, R3, L2, R5, R5, L4, L1, L2, R185, L5, R2, R1, L3, R4, L5, R2, R4, L3, R4, L2, L5, R1, R2, L2, L1, L2, R2, L2, R1, L5, L3, L4, L3, L4, L2, L5, L5, R2, L3, L4, R4, R4, R5, L4, L2, R4, L5, R3, R1, L1, R3, L2, R2, R1, R5, L4, R5, L3, R2, R3, R1, R4, L4, R1, R3, L5, L1, L3, R2, R1, R4, L4, R3, L3, R3, R2, L3, L3, R4, L2, R4, L3, L4, R5, R1, L1, R5, R3, R1, R3, R4, L1, R4, R3, R1, L5, L5, L4, R4, R3, L2, R1, R5, L3, R4, R5, L4, L5, R2
