require 'test-helper'
require '2023/day-20-pulse-propagation'

class TestPulsePropagation < Minitest::Test
  def setup
    @input = <<END
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
END
    @input2 = <<END
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
END
    @subject = PulsePropagation.parse(@input)
    @subject2 = PulsePropagation.parse(@input2)
  end

  def test_pulse_product
    assert_equal 32000000, @subject.pulse_product
    assert_equal 11687500, @subject2.pulse_product
  end
end
