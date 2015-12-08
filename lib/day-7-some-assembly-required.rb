=begin

--- Day 7: Some Assembly Required ---

This year, Santa brought little Bobby Tables a set of wires and bitwise logic gates! Unfortunately, little Bobby is
a little under the recommended age range, and he needs help assembling the circuit.

Each wire has an identifier (some lowercase letters) and can carry a 16-bit signal (a number from 0 to 65535). A
signal is provided to each wire by a gate, another wire, or some specific value. Each wire can only get a signal
from one source, but can provide its signal to multiple destinations. A gate provides no signal until all of its
inputs have a signal.

The included instructions booklet describes how to connect the parts together: x AND y -> z means to connect wires
x and y to an AND gate, and then connect its output to wire z.

For example:

 - 123 -> x means that the signal 123 is provided to wire x.
 - x AND y -> z means that the bitwise AND of wire x and wire y is provided to wire z.
 - p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and then provided to wire q.
 - NOT e -> f means that the bitwise complement of the value from wire e is provided to wire f.

Other possible gates include OR (bitwise OR) and RSHIFT (right-shift). If, for some reason, you'd like to emulate
the circuit instead, almost all programming languages (for example, C, JavaScript, or Python) provide operators for
these gates.

For example, here is a simple circuit:

123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i

After it is run, these are the signals on the wires:

d: 72
e: 507
f: 492
g: 114
h: 65412
i: 65079
x: 123
y: 456

In little Bobby's kit's instructions booklet (provided as your puzzle input), what signal is ultimately provided to
wire a?

=end

class Circuit
  def initialize(circuit)
    @wires = {}
    circuit.split("\n").each &method(:connect)
  end

  def wires
    @wires.map { |wire, proc| [wire.to_sym, proc.call] }.to_h
  end

  private

  def connect(wire_spec)
    return unless wire_spec =~ /^(.+) -> ([a-z]+)$/
    wire = $2
    case $1
    when /^(\d+)$/
      signal = $1.to_i
      @wires[wire] = -> { signal }
    when /^([a-z]+) (AND|OR) ([a-z]+)$/
      in1, op, in2 = $1, $2, $3
      @wires[wire] = -> { binary_gate(op, @wires[in1].call, @wires[in2].call) }
    when /^([a-z]+) (LSHIFT|RSHIFT) (\d+)$/
      input, op, shift = $1, $2, $3
      @wires[wire] = -> { shift_gate(op, @wires[input].call, shift.to_i) }
    when /^NOT ([a-z]+)$/
      input = $1
      @wires[wire] = -> { not_gate(@wires[input].call) }
    end
  end

  def binary_gate(op, signal1, signal2)
    case op
    when 'AND'
      signal1 & signal2
    when 'OR'
      signal1 | signal2
    end
  end

  def shift_gate(op, signal, shift)
    case op
    when 'LSHIFT'
      signal << shift
    when 'RSHIFT'
      signal >> shift
    end
  end

  def not_gate(signal)
    ~signal % 65536 # convert to unsigned 16-bit
  end
end
