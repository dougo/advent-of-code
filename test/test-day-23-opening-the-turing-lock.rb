require 'test-helper'
require 'day-23-opening-the-turing-lock'

class TestDay23OpeningTheTuringLock < Minitest::Test
  def setup
    @subject = Computer.new
  end

  def test_example
    # For example, this program sets a to 2, because the jio instruction causes it to skip the tpl instruction:
    input = <<END
inc a
jio a, +2
tpl a
inc a
END
    assert_equal 2, @subject.run_program(input)['a']
    assert_equal 7, @subject.run_program(input, 1)['a']
  end

  def test_hlf
    # - hlf r sets register r to half its current value, then continues with the next instruction.
    assert_equal 0, @subject.run_program("hlf a")['a']
    assert_equal 1, @subject.run_program("inc a\ninc a\nhlf a")['a']
    assert_equal 1, @subject.run_program("inc b\ninc b\nhlf b")['b']
  end

  def test_tpl
    # - tpl r sets register r to triple its current value, then continues with the next instruction.
    # TODO
  end

  def test_inc
    # - inc r increments register r, adding 1 to it, then continues with the next instruction.
    assert_equal 1, @subject.run_program("inc a")['a']
    assert_equal 2, @subject.run_program("inc a\ninc a")['a']
    assert_equal 1, @subject.run_program("inc b")['b']
  end

  def test_jmp
    # - jmp offset is a jump; it continues with the instruction offset away relative to itself.
    # TODO
  end

  def test_jie
    # - jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
    # TODO
  end

  def test_jio
    # - jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
    # TODO
  end
end
