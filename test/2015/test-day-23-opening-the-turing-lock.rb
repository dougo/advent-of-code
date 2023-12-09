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
    assert_equal 2, run_program(input)['a']
    assert_equal 7, run_program(input, a: 1)['a']
  end

  def test_hlf
    # - hlf r sets register r to half its current value, then continues with the next instruction.
    assert_equal 0, Computer.new("hlf a").step['a']
    assert_equal 1, Computer.new("hlf a").step.pc
    assert_equal 21, Computer.new("hlf a", a: 42).step['a']
    assert_equal 2, Computer.new("hlf b", "hlf b", b: 8).step.step['b']
  end

  def test_tpl
    # - tpl r sets register r to triple its current value, then continues with the next instruction.
    assert_equal 0, Computer.new("tpl a").step['a']
    assert_equal 1, Computer.new("tpl a").step.pc
    assert_equal 42, Computer.new("tpl a", a: 14).step['a']
    assert_equal 9, Computer.new("tpl b", "tpl b", b: 1).step.step['b']
  end

  def test_inc
    # - inc r increments register r, adding 1 to it, then continues with the next instruction.
    assert_equal 1, Computer.new("inc a").step['a']
    assert_equal 1, Computer.new("inc a").step.pc
    assert_equal 42, Computer.new("inc b", b: 41).step['b']
    assert_equal 2, Computer.new("inc a", "inc a").step.step['a']
  end

  def test_jmp
    # - jmp offset is a jump; it continues with the instruction offset away relative to itself.
    # For example, jmp +1 would simply continue with the next instruction, while jmp +0 would continuously jump
    # back to itself forever.
    assert_equal 1, Computer.new("jmp +1").step.pc
    assert_equal 0, Computer.new("jmp +0").step.pc
    assert_equal 2, Computer.new("jmp +2").step.pc
    assert_equal (-1), Computer.new("jmp -1").step.pc
    assert_equal 0, Computer.new("jmp +2", "jmp -1", pc: 1).step.pc
  end

  def test_jie
    # - jie r, offset is like jmp, but only jumps if register r is even ("jump if even").
    assert_equal 2, Computer.new("jie a, +2").step.pc
    assert_equal 1, Computer.new("jie a, +2", a: 1).step.pc
    assert_equal 3, Computer.new("jie a, +3", a: 2).step.pc
    assert_equal 1, Computer.new("jie b, +3", b: 3).step.pc
    assert_equal 0, Computer.new("jie a, +2", "jie a, -1", pc: 1).step.pc

    assert_equal 3, Computer.new("inc a", "jie a, -1", a: 1).run['a']
  end

  def test_jio
    # - jio r, offset is like jmp, but only jumps if register r is 1 ("jump if one", not odd).
    assert_equal 1, Computer.new("jio a, +2").step.pc
    assert_equal 2, Computer.new("jio a, +2", a: 1).step.pc
    assert_equal 1, Computer.new("jio a, +3", a: 2).step.pc
    assert_equal 1, Computer.new("jio b, +3", b: 3).step.pc
    assert_equal 0, Computer.new("jio b, +3", "jio b, -1", b: 1, pc: 1).step.pc

    assert_equal 2, Computer.new("inc a", "jio a, -1").run['a']
  end

  def test_illegal_instruction
    ex = assert_raises { Computer.new("hcf").step }
    assert_equal 'Illegal instruction: hcf', ex.message
  end
end
