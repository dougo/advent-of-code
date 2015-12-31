require 'test-helper'
require 'day-23-opening-the-turing-lock'

class TestDay23OpeningTheTuringLock < Minitest::Test
  def test_run_program
    input = <<END
inc a
jio a, +2
tpl a
inc a
END
    assert_equal 2, Computer.new.run_program(input)['a']
    assert_equal 7, Computer.new.run_program(input, 1)['a']
  end

  # TODO: test other instructions: hlf, jmp, jie, jio when odd > 1
end
