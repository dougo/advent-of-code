require 'test-helper'
require 'day-7-some-assembly-required'

class TestDay7SomeAssemblyRequired < Minitest::Test
  def test_wires
    input = <<END
123 -> x
456 -> y
x AND y -> d
x OR y -> e
x LSHIFT 2 -> f
y RSHIFT 2 -> g
NOT x -> h
NOT y -> i
END
    expected_signals = {
      d: 72,
      e: 507,
      f: 492,
      g: 114,
      h: 65412,
      i: 65079,
      x: 123,
      y: 456
    }
    assert_equal expected_signals, Circuit.new(input).wires
  end
end
