=begin

--- Day 19: Medicine for Rudolph ---

Rudolph the Red-Nosed Reindeer is sick! His nose isn't shining very brightly, and he needs medicine.

Red-Nosed Reindeer biology isn't similar to regular reindeer biology; Rudolph is going to need custom-made
medicine. Unfortunately, Red-Nosed Reindeer chemistry isn't similar to regular reindeer chemistry, either.

The North Pole is equipped with a Red-Nosed Reindeer nuclear fusion/fission plant, capable of constructing any
Red-Nosed Reindeer molecule you need. It works by starting with some input molecule and then doing a series of
replacements, one per step, until it has the right molecule.

However, the machine has to be calibrated before it can be used. Calibration involves determining the number of
molecules that can be generated in one step from a given starting point.

For example, imagine a simpler machine that supports only the following replacements:

H => HO
H => OH
O => HH

Given the replacements above and starting with HOH, the following molecules could be generated:

 - HOOH (via H => HO on the first H).
 - HOHO (via H => HO on the second H).
 - OHOH (via H => OH on the first H).
 - HOOH (via H => OH on the second H).
 - HHHH (via O => HH).

So, in the example above, there are 4 distinct molecules (not five, because HOOH appears twice) after one
replacement from HOH. Santa's favorite molecule, HOHOHO, can become 7 distinct molecules (over nine replacements:
six from H, and three from O).

The machine replaces without regard for the surrounding characters. For example, given the string H2O, the
transition H => OO would result in OO2O.

Your puzzle input describes all of the possible replacements and, at the bottom, the medicine molecule for which
you need to calibrate the machine. How many distinct molecules can be created after all the different ways you can
do one replacement on the medicine molecule?

--- Part Two ---

Now that the machine is calibrated, you're ready to begin molecule fabrication.

Molecule fabrication always begins with just a single electron, e, and applying replacements one at a time, just
like the ones during calibration.

For example, suppose you have the following replacements:

e => H
e => O
H => HO
H => OH
O => HH

If you'd like to make HOH, you start with e, and then make the following replacements:

 - e => O to get O
 - O => HH to get HH
 - H => OH (on the second H) to get HOH

So, you could make HOH after 3 steps. Santa's favorite molecule, HOHOHO, can be made in 6 steps.

How long will it take to make the medicine? Given the available replacements and the medicine molecule in your
puzzle input, what is the fewest number of steps to go from e to the medicine molecule?

=end

require 'set'
require_relative 'util'

class MoleculeFabricator
  def self.parse(input)
    rep_lines, medicine = input.split("\n\n")
    replacements = rep_lines.split("\n").map { |rep| rep.split(' => ') }
    new(replacements, medicine)
  end

  def initialize(*args)
    @replacements, @medicine = args
  end
    
  attr_reader :replacements, :medicine, :reverse_replacements

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
