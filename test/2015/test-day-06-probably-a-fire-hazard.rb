require 'test-helper'
require '2015/day-06-probably-a-fire-hazard'

class TestDay6ProbablyAFireHazard < Minitest::Test
  def setup
    @input = <<END
turn on 0,0 through 999,999
toggle 0,0 through 999,0
turn off 499,499 through 500,500
END
    @new_input = <<END
turn on 0,0 through 0,0
toggle 0,0 through 999,999
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

  def test_corrected_do_instruction
    input = @new_input.split("\n")

    # turn on 0,0 through 0,0 would increase the total brightness by 1.
    assert_equal 1, CorrectedLights.new.do_instruction(input[0]).brightness

    # toggle 0,0 through 999,999 would increase the total brightness by 2000000.
    assert_equal 2_000_000, CorrectedLights.new.do_instruction(input[1]).brightness
  end

  def test_do_instructions
    assert_equal 998_996, Lights.new.do_instructions(@input).num_lit
    assert_equal 1_001_996, CorrectedLights.new.do_instructions(@input).brightness
    assert_equal 2_000_001, CorrectedLights.new.do_instructions(@new_input).brightness
  end
end
