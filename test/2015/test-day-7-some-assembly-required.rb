require 'test-helper'
require 'day-7-some-assembly-required'

class TestDay7SomeAssemblyRequired < Minitest::Test
  def test_wire_signals
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
    assert_equal expected_signals, Circuit.new(input).wire_signals
    assert_equal 114, Circuit.new(input).wire_signal(:g)
  end
end
