require 'test-helper'
require 'day-19-medicine-for-rudolph'

class TestDay19MedicineForRudolph < Minitest::Test
  def setup
    @input = <<END
e => H
e => O
H => HO
H => OH
O => HH

HOH
END
    @subject = MoleculeFabricator.new(@input.chomp)
  end

  def test_parse_molecule
    assert_equal %w(), @subject.parse_molecule('')
    assert_equal %w(e), @subject.parse_molecule('e')
    assert_equal %w(H), @subject.parse_molecule('H')
    assert_equal %w(H O), @subject.parse_molecule('HO')
    assert_equal %w(He H), @subject.parse_molecule('HeH') 
    assert_equal %w(H Ar), @subject.parse_molecule('HAr')
    assert_equal %w(He Li C O Pt Er S), @subject.parse_molecule('HeLiCOPtErS')
  end

  def test_parse_replacement
    rep = @subject.parse_replacement('He => LiCO')
    assert_equal 'He', rep.atom
    assert_equal %w(Li C O), rep.atoms
    assert_equal 'He => LiCO', rep.to_s
  end

  def test_initialize
    assert_equal 3, @subject.replacements.length
    assert_equal %w(H), @subject.replacements['e'][0].atoms
    assert_equal %w(O), @subject.replacements['e'][1].atoms
    assert_equal %w(H O), @subject.replacements['H'][0].atoms
    assert_equal %w(O H), @subject.replacements['H'][1].atoms
    assert_equal %w(H H), @subject.replacements['O'][0].atoms
    assert_equal 'HOH', @subject.medicine
    assert_equal @input.chomp, @subject.to_s
  end

  def test_next_molecules
    # Given the replacements above and starting with HOH, the following molecules could be generated:
    # - HOOH (via H => HO on the first H).
    # - HOHO (via H => HO on the second H).
    # - OHOH (via H => OH on the first H).
    # - HOOH (via H => OH on the second H).
    # - HHHH (via O => HH).
    # So, in the example above, there are 4 distinct molecules (not five, because HOOH appears twice) after one
    # replacement from HOH.
    assert_equal %w(HOOH HOHO OHOH HHHH).to_set, @subject.next_molecules.map(&:join).to_set

    # Santa's favorite molecule, HOHOHO, can become 7 distinct molecules (over nine replacements: six from H, and
    # three from O).
    assert_equal 7, @subject.next_molecules(@subject.parse_molecule('HOHOHO')).size
  end

  def test_fewest_steps_to
    # If you'd like to make HOH, you start with e, and then make the following replacements:
    # - e => O to get O
    # - O => HH to get HH
    # - H => OH (on the second H) to get HOH
    # So, you could make HOH after 3 steps.
    assert_equal 3, @subject.fewest_steps_to

    # Santa's favorite molecule, HOHOHO, can be made in 6 steps.
    assert_equal 6, @subject.fewest_steps_to(@subject.parse_molecule('HOHOHO'))
  end
end
