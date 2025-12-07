require_relative '../util'

class MoleculeFabricator
  def self.parse(input)
    rep_lines, medicine = input.split("\n\n")
    replacements = rep_lines.split("\n").map { |rep| rep.split(' => ') }
    new(replacements, medicine)
  end

  def initialize(*args)
    @replacements, @medicine = args
  end
    
  attr_reader :replacements, :medicine # , :reverse_replacements

  def next_molecules(molecule = medicine)
    replacements.flat_map do |left, right|
      (0...molecule.length).map do |i|
        if molecule[i..-1].start_with? left
          molecule[0...i] + right + molecule[i+left.length..-1]
        end
      end.compact
    end.uniq
  end

  def reverse_replacements
    replacements.map { |left, right| [right, left] }
  end

  def previous_molecules(molecule = medicine)
    self.class.new(reverse_replacements, molecule).next_molecules
  end

  def fewest_steps_to(molecule = medicine)
    return 0 if molecule == 'e'
    previous_molecules(molecule).each do |prev|
      prev_steps = fewest_steps_to(prev)
      # TODO: This only works if the first path found is the shortest...
      # Is there an efficient way to verify that it's the shortest?
      return prev_steps + 1 if prev_steps
    end
    nil
  end
end

if defined? DATA
  input = DATA.read.chomp

  fab = MoleculeFabricator.parse(input)
  puts fab.next_molecules.length
  puts fab.fewest_steps_to
end

__END__
Al => ThF
Al => ThRnFAr
B => BCa
B => TiB
B => TiRnFAr
Ca => CaCa
Ca => PB
Ca => PRnFAr
Ca => SiRnFYFAr
Ca => SiRnMgAr
Ca => SiTh
F => CaF
F => PMg
F => SiAl
H => CRnAlAr
H => CRnFYFYFAr
H => CRnFYMgAr
H => CRnMgYFAr
H => HCa
H => NRnFYFAr
H => NRnMgAr
H => NTh
H => OB
H => ORnFAr
Mg => BF
Mg => TiMg
N => CRnFAr
N => HSi
O => CRnFYFAr
O => CRnMgAr
O => HP
O => NRnFAr
O => OTi
P => CaP
P => PTi
P => SiRnFAr
Si => CaSi
Th => ThCa
Ti => BP
Ti => TiTi
e => HF
e => NAl
e => OMg

CRnSiRnCaPTiMgYCaPTiRnFArSiThFArCaSiThSiThPBCaCaSiRnSiRnTiTiMgArPBCaPMgYPTiRnFArFArCaSiRnBPMgArPRnCaPTiRnFArCaSiThCaCaFArPBCaCaPTiTiRnFArCaSiRnSiAlYSiThRnFArArCaSiRnBFArCaCaSiRnSiThCaCaCaFYCaPTiBCaSiThCaSiThPMgArSiRnCaPBFYCaCaFArCaCaCaCaSiThCaSiRnPRnFArPBSiThPRnFArSiRnMgArCaFYFArCaSiRnSiAlArTiTiTiTiTiTiTiRnPMgArPTiTiTiBSiRnSiAlArTiTiRnPMgArCaFYBPBPTiRnSiRnMgArSiThCaFArCaSiThFArPRnFArCaSiRnTiBSiThSiRnSiAlYCaFArPRnFArSiThCaFArCaCaSiThCaCaCaSiRnPRnCaFArFYPMgArCaPBCaPBSiRnFYPBCaFArCaSiAl
