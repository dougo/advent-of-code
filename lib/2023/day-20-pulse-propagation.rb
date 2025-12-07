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
    @button_presses = 0
    @output_received_low = false
  end

  attr :modules, :pulse_queue, :pulses_sent
  attr_accessor :button_presses, :output_received_low

  def connect_modules
    modules.values.each do |source|
      source.destinations.each do |dest|
        unless modules.has_key?(dest)
          modules[dest] = Output.new(dest)
        end
        modules[dest].add_input(source.name)
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
      @inputs = []
    end

    attr :name, :destinations, :inputs

    def add_input(source)
      @inputs << source
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
      super
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
      system.button_presses += 1
      send_pulse(system, :low)
    end
  end

  class Output < Module
    def initialize(name)
      super(name, [])
    end

    def receive_pulse(system, pulse)
      system.output_received_low = true if pulse.type == :low
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

  def num_button_presses_for_output_to_receive_low
    5000.times do
      push_button
      break if output_received_low
    end
    self.output_received_low = false
    button_presses
  end

  def print_graphml
    puts <<END
<?xml version="1.0" encoding="UTF-8"?>
<graphml xmlns="http://graphml.graphdrawing.org/xmlns"  
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://graphml.graphdrawing.org/xmlns
     http://graphml.graphdrawing.org/xmlns/1.0/graphml.xsd">
  <graph id="G" edgedefault="directed">
END
    modules.keys.each { puts "    <node id='#{_1}'/>" }
    modules.each do |source, mod|
      mod.destinations.each do |target|
        puts "    <edge source='#{source}' target='#{target}'/>"
      end
    end
    puts <<END
  </graph>
</graphml>
END
  end
end

if defined? DATA
  input = DATA.read
  system = PulsePropagation.parse(input)
  puts system.pulse_product
  # system.print_graphml

  # After loading the graphml into a visualizer, I saw that there are four subconfigs in parallel.
  # I ran those separately to get their periods:
  puts [4057, 3793, 3947, 3733].reduce(:lcm)
  # TODO: write code to actually figure this out?
end

# see graph: http://graphonline.ru/en/?graph=YdaBwmeOKqGuEehw

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
