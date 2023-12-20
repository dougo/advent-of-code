=begin

--- Day 20: Pulse Propagation ---

With your help, the Elves manage to find the right parts and fix all of the machines. Now, they just need to send
the command to boot up the machines and get the sand flowing again.

The machines are far apart and wired together with long cables. The cables don't connect to the machines directly,
but rather to communication modules attached to the machines that perform various initialization tasks and also act
as communication relays.

Modules communicate using pulses. Each pulse is either a high pulse or a low pulse. When a module sends a pulse, it
sends that type of pulse to each module in its list of destination modules.

There are several different types of modules:

Flip-flop modules (prefix %) are either on or off; they are initially off. If a flip-flop module receives a high
pulse, it is ignored and nothing happens. However, if a flip-flop module receives a low pulse, it flips between on
and off. If it was off, it turns on and sends a high pulse. If it was on, it turns off and sends a low pulse.

Conjunction modules (prefix &) remember the type of the most recent pulse received from each of their connected
input modules; they initially default to remembering a low pulse for each input. When a pulse is received, the
conjunction module first updates its memory for that input. Then, if it remembers high pulses for all inputs, it
sends a low pulse; otherwise, it sends a high pulse.

There is a single broadcast module (named broadcaster). When it receives a pulse, it sends the same pulse to all of
its destination modules.

Here at Desert Machine Headquarters, there is a module with a single button on it called, aptly, the button
module. When you push the button, a single low pulse is sent directly to the broadcaster module.

After pushing the button, you must wait until all pulses have been delivered and fully handled before pushing it
again. Never push the button if modules are still processing pulses.

Pulses are always processed in the order they are sent. So, if a pulse is sent to modules a, b, and c, and then
module a processes its pulse and sends more pulses, the pulses sent to modules b and c would have to be handled
first.

The module configuration (your puzzle input) lists each module. The name of the module is preceded by a symbol
identifying its type, if any. The name is then followed by an arrow and a list of its destination modules. For
example:

broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a

In this module configuration, the broadcaster has three destination modules named a, b, and c. Each of these
modules is a flip-flop module (as indicated by the % prefix). a outputs to b which outputs to c which outputs to
another module named inv. inv is a conjunction module (as indicated by the & prefix) which, because it has only one
input, acts like an inverter (it sends the opposite of the pulse type it receives); it outputs to a.

By pushing the button once, the following pulses are sent:

button -low-> broadcaster
broadcaster -low-> a
broadcaster -low-> b
broadcaster -low-> c
a -high-> b
b -high-> c
c -high-> inv
inv -low-> a
a -low-> b
b -low-> c
c -low-> inv
inv -high-> a

After this sequence, the flip-flop modules all end up off, so pushing the button again repeats the same sequence.

Here's a more interesting example:

broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output

This module configuration includes the broadcaster, two flip-flops (named a and b), a single-input conjunction module (inv), a multi-input conjunction module (con), and an untyped module named output (for testing purposes). The multi-input conjunction module con watches the two flip-flop modules and, if they're both on, sends a low pulse to the output module.

Here's what happens if you push the button once:

button -low-> broadcaster
broadcaster -low-> a
a -high-> inv
a -high-> con
inv -low-> b
con -high-> output
b -high-> con
con -low-> output

Both flip-flops turn on and a low pulse is sent to output! However, now that both flip-flops are on and con remembers a high pulse from each of its two inputs, pushing the button a second time does something different:

button -low-> broadcaster
broadcaster -low-> a
a -low-> inv
a -low-> con
inv -high-> b
con -high-> output

Flip-flop a turns off! Now, con remembers a low pulse from module a, and so it sends only a high pulse to output.

Push the button a third time:

button -low-> broadcaster
broadcaster -low-> a
a -high-> inv
a -high-> con
inv -low-> b
con -low-> output
b -low-> con
con -high-> output

This time, flip-flop a turns on, then flip-flop b turns off. However, before b can turn off, the pulse sent to con
is handled first, so it briefly remembers all high pulses for its inputs and sends a low pulse to output. After
that, flip-flop b turns off, which causes con to update its state and send a high pulse to output.

Finally, with a on and b off, push the button a fourth time:

button -low-> broadcaster
broadcaster -low-> a
a -low-> inv
a -low-> con
inv -high-> b
con -high-> output

This completes the cycle: a turns off, causing con to remember only low pulses and restoring all modules to their
original states.

To get the cables warmed up, the Elves have pushed the button 1000 times. How many pulses got sent as a result
(including the pulses sent by the button itself)?

In the first example, the same thing happens every time the button is pushed: 8 low pulses and 4 high pulses are
sent. So, after pushing the button 1000 times, 8000 low pulses and 4000 high pulses are sent. Multiplying these
together gives 32000000.

In the second example, after pushing the button 1000 times, 4250 low pulses and 2750 high pulses are
sent. Multiplying these together gives 11687500.

Consult your module configuration; determine the number of low pulses and high pulses that would be sent after
pushing the button 1000 times, waiting for all pulses to be fully handled after each push of the button. What do
you get if you multiply the total number of low pulses sent by the total number of high pulses sent?

=end

require_relative '../util'

class PulsePropagation
  def self.parse(text)
    modules = text.lines(chomp: true).map { Module.parse(_1) }
    new(modules + [Button.new])
  end

  def initialize(modules)
    @modules = modules.index_by(&:name)
    connect_modules
    @pulse_queue = []
    @pulses_sent = { high: 0, low: 0 }
  end

  attr :modules, :pulse_queue, :pulses_sent

  def connect_modules
    modules.values.each do |source|
      source.destinations.each do |dest|
        if modules.has_key?(dest)
          modules[dest].add_input(source.name)
        else
          modules[dest] = Output.new(dest)
        end
      end
    end
  end

  class Module
    def self.parse(text)
      text =~ /([%&]?)(.*) -> (.*)/
      type, name, destinations = $1, $2.to_sym, $3.split(', ').map(&:to_sym)
      subclass = case type
                 when '%' then FlipFlop
                 when '&' then Conjunction
                 else Broadcast if name == :broadcaster
                 end
      subclass.new(name, destinations)
    end

    def initialize(*args)
      @name, @destinations = *args
    end

    attr :name, :destinations

    def add_input(source)
    end

    def send_pulse(system, pulse_type)
      destinations.each do |dest|
        system.send_pulse(Pulse[name, pulse_type, dest])
      end
    end

    def receive_pulse(system, pulse)
    end
  end

  class FlipFlop < Module
    def initialize(...)
      @on = false
      super
    end

    attr_accessor :on

    def receive_pulse(system, pulse)
      if pulse.type == :low
        self.on = !on
        send_pulse(system, on ? :high : :low)
      end
    end
  end

  class Conjunction < Module
    def initialize(...)
      super
      @remembered_pulse_types = {}
    end

    attr :remembered_pulse_types

    def add_input(source)
      remembered_pulse_types[source] = :low
    end

    def receive_pulse(system, pulse)
      remembered_pulse_types[pulse.source] = pulse.type
      send_pulse(system, pulse_type_to_send)
    end

    def pulse_type_to_send
      remembered_pulse_types.values.all? { _1 == :high } ? :low : :high
    end
  end

  class Broadcast < Module
    def receive_pulse(system, pulse)
      send_pulse(system, pulse.type)
    end
  end

  class Button < Module
    def initialize
      super(:button, [:broadcaster])
    end

    def push(system)
      send_pulse(system, :low)
    end
  end

  class Output < Module
    def initialize(name)
      super(name, [])
    end
  end

  Pulse = Data.define(:source, :type, :destination) do
    def to_s
      "#{source} -#{type}-> #{destination}"
    end
  end

  def send_pulse(pulse)
    pulse_queue << pulse
    pulses_sent[pulse.type] += 1
  end

  def push_button
    modules[:button].push(self)
    until pulse_queue.empty?
      pulse = pulse_queue.shift
      modules[pulse.destination].receive_pulse(self, pulse)
    end
  end

  def pulse_product
    1000.times { push_button }
    pulses_sent[:low] * pulses_sent[:high]
  end
end

if defined? DATA
  input = DATA.read
  system = PulsePropagation.parse(input)
  puts system.pulse_product
end

__END__
%hb -> mj
%mx -> mt, xz
%xh -> qc
%tg -> cq
%kp -> xz, nj
%mj -> jj, lv
%cq -> jm
%mt -> sj, xz
&jj -> hb, lz, rk, xv, vj, vh, lv
%rm -> bz, xq
%hx -> bz
%xv -> lz
%xx -> kp, xz
%pt -> vx
&xz -> bq, gr, sj, rv, zf
%vx -> gf, cv
%xb -> xz, bq
%xk -> gf, rd
%lv -> zk
&rk -> gh
%kn -> gf, tz
&gh -> rx
%sj -> vp
%jm -> vm, bz
%rr -> rv, xz
%tz -> rz
%gg -> kn
&cd -> gh
%qc -> kh, bz
%kb -> gf
%vp -> xz, xx
%fb -> bz, tg
%rd -> cp
%qn -> vh, jj
%xr -> jj
%tp -> rm, bz
%cp -> gg
&bz -> qx, cq, xh, fb, tg
%qq -> pt, gf
%xq -> bz, hx
%gx -> jj, qv
%bq -> rr
%cv -> gf, kb
%zk -> jj, xv
&zf -> gh
&qx -> gh
%vh -> gx
%qv -> xr, jj
%lz -> qn
broadcaster -> fb, xk, gr, vj
%nj -> xz
%gr -> xz, xb
%kh -> tp, bz
%vm -> bz, xh
%rz -> qq, gf
&gf -> tz, cd, rd, xk, pt, cp, gg
%rv -> mx
%vj -> hb, jj
