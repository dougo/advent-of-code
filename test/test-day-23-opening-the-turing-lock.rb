require 'test-helper'
require 'day-23-opening-the-turing-lock'

class TestDay23OpeningTheTuringLock < Minitest::Test
  def test_example
    # For example, this program sets a to 2, because the jio instruction causes it to skip the tpl instruction:
    input = <<END
inc a
jio a, +2
tpl a
inc a
END
    assert_equal 2, Computer.new.run_program(input)['a']
    assert_equal 7, Computer.new(a: 1).run_program(input)['a']
  end

  def test_hlf
    # - hlf r sets register r to half its current value, then continues with the next instruction.
    assert_equal 0, Computer.new.run_program("hlf a")['a']
    assert_equal 1, Computer.new(a: 2).run_program("hlf a")['a']
    assert_equal 2, Computer.new(b: 8).run_program("hlf b\nhlf b")['b']
  end

  def test_tpl
    # - tpl r sets register r to triple its current value, then continues with the next instruction.
    assert_equal 0, Computer.new.run_program("tpl a")['a']
    assert_equal 3, Computer.new(a: 1).run_program("tpl a")['a']
    assert_equal 9, Computer.new(b: 1).run_program("tpl b\ntpl b")['b']
  end

  def test_inc
    # - inc r increments register r, adding 1 to it, then continues with the next instruction.
    assert_equal 1, Computer.new.run_program("inc a")['a']
    assert_equal 2, Computer.new.run_program("inc a\ninc a")['a']
    assert_equal 1, Computer.new.run_program("inc b")['b']
  end

  def test_jmp
    # - jmp offset is a jump; it continues with the instruction offset away relative to itself.
    # For example, jmp +1 would simply continue with the next instruction
    assert_equal 1, Computer.new.run_program("jmp +1\ninc a")['a']
    assert_equal 1, Computer.new.run_program("jmp +2\ninc a\ninc a")['a']
    assert_equal 0, Computer.new.run_program("jmp +2\ninc a")['a']
    assert_equal 0, Computer.new.run_program("jmp -1\ninc a")['a']
  end

  def test_jie
    # - jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
    assert_equal 0, Computer.new.run_program("jie a, +2\ninc a")['a']
    assert_equal 2, Computer.new(a: 1).run_program("jie a, +2\ninc a")['a']
    assert_equal 4, Computer.new(b: 3).run_program("jie b, +2\ninc b")['b']
    assert_equal 3, Computer.new(a: 1).run_program("inc a\njie a, -1")['a']
  end

  def test_jio
    # - jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
    assert_equal 1, Computer.new.run_program("jio a, +2\ninc a")['a']
    assert_equal 1, Computer.new(a: 1).run_program("jio a, +2\ninc a")['a']
    assert_equal 1, Computer.new(b: 1).run_program("jio b, +2\ninc b")['b']
    assert_equal 4, Computer.new(b: 3).run_program("jio b, +2\ninc b")['b']
    assert_equal 2, Computer.new.run_program("inc a\njio a, -1")['a']
  end
end
