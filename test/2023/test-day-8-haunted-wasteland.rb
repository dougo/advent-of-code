require 'test-helper'
require '2023/day-8-haunted-wasteland'

class TestHauntedWasteland < Minitest::Test
  def setup
    @subject = HauntedWasteland.new <<END
RL

AAA = (BBB, CCC)
BBB = (DDD, EEE)
CCC = (ZZZ, GGG)
DDD = (DDD, DDD)
EEE = (EEE, EEE)
GGG = (GGG, GGG)
ZZZ = (ZZZ, ZZZ)
END
    @subject2 = HauntedWasteland.new <<END
LLR

AAA = (BBB, BBB)
BBB = (AAA, ZZZ)
ZZZ = (ZZZ, ZZZ)
END
  end

  def test_steps_required
    assert_equal 2, @subject.steps_required
    assert_equal 6, @subject2.steps_required
  end
end
