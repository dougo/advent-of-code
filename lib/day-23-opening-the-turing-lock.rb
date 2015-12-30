# TODO: tests!!

require_relative 'util'

def run(input, a = 0)
  instrs = input.split("\n")
  t = 0
  pc = 0
  reg = { 'a' => a, 'b' => 0 }
  while pc.in?(0...instrs.length)
    puts "reg = #{reg}"
    instr = instrs[pc]
    puts "pc = #{pc}, instr = #{instr.inspect}"
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

p run <<END
inc a
jio a, +2
tpl a
inc a
END

if defined? DATA
  input = DATA.read
  puts run(input)['b']
  puts run(input, 1)['b']
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
