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
    @subject3 = HauntedWasteland.new <<END
LR

11A = (11B, XXX)
11B = (XXX, 11Z)
11Z = (11B, XXX)
22A = (22B, XXX)
22B = (22C, 22C)
22C = (22Z, 22Z)
22Z = (22B, 22B)
XXX = (XXX, XXX)
END
  end

  def test_steps_required
    assert_equal 2, @subject.steps_required
    assert_equal 6, @subject2.steps_required
  end

  def test_steps_required_for_ghosts
    assert_equal 6, @subject3.steps_required_for_ghosts
  end
end
