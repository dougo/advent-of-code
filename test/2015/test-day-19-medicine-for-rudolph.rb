require 'test-helper'
require '2015/day-19-medicine-for-rudolph'

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
    @subject = MoleculeFabricator.parse(@input.chomp)
  end

  def test_parse
    assert_equal [%w(e H), %w(e O), %w(H HO), %w(H OH), %w(O HH)], @subject.replacements
    assert_equal 'HOH', @subject.medicine
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
    assert_equal %w(HOOH HOHO OHOH HHHH).to_set, @subject.next_molecules.to_set

    # Santa's favorite molecule, HOHOHO, can become 7 distinct molecules (over nine replacements: six from H, and
    # three from O).
    assert_equal 7, @subject.next_molecules('HOHOHO').size

    fab = MoleculeFabricator.parse("A => B\n\nC")
    assert_empty fab.next_molecules
  end

  def test_reverse_replacements
    assert_equal [%w(H e), %w(O e), %w(HO H), %w(OH H), %w(HH O)], @subject.reverse_replacements
  end

  def test_prev_molecules
    assert_equal %w(eOH HeH HOe HH).to_set, @subject.previous_molecules.to_set
  end

  def test_fewest_steps_to
    # If you'd like to make HOH, you start with e, and then make the following replacements:
    # - e => O to get O
    # - O => HH to get HH
    # - H => OH (on the second H) to get HOH
    # So, you could make HOH after 3 steps.
    assert_equal 3, @subject.fewest_steps_to

    # Santa's favorite molecule, HOHOHO, can be made in 6 steps.
    assert_equal 6, @subject.fewest_steps_to('HOHOHO')

    assert_equal 0, @subject.fewest_steps_to('e')
    assert_nil @subject.fewest_steps_to('XX')
    assert_nil @subject.fewest_steps_to('HX')
  end
end
