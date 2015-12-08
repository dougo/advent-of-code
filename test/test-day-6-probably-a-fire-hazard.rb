require 'test-helper'
require 'day-6-probably-a-fire-hazard'

class TestDay6ProbablyAFireHazard < Minitest::Test
  def setup
    @input = <<END
turn on 0,0 through 999,999
toggle 0,0 through 999,0
turn off 499,499 through 500,500
END
  end

  def test_do_instruction
    input = @input.split("\n")

    # turn on 0,0 through 999,999 would turn on (or leave on) every light.
    assert_equal 1_000_000, Lights.new.do_instruction(input[0]).num_lit

    # toggle 0,0 through 999,0 would toggle the first line of 1000 lights, turning off the ones that were on, and
    # turning on the ones that were off.
    assert_equal 1_000, Lights.new.do_instruction(input[1]).num_lit

    # turn off 499,499 through 500,500 would turn off (or leave off) the middle four lights.
    assert_equal 0, Lights.new.do_instruction(input[2]).num_lit
  end

  def test_do_instructions
    assert_equal 998_996, Lights.new.do_instructions(@input).num_lit
  end
end
