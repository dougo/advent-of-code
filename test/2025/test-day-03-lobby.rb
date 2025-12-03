require 'test-helper'
require '2025/day-03'

class TestLobby < Minitest::Test
  def setup
    @part1 = <<END
987654321111111
811111111111119
234234234234278
818181911112111
END
  end

  def test_lobby_part_1
    @subject = Lobby.new(@part1)

    assert_equal [98, 89, 78, 92], @subject.maximum_joltages
    assert_equal 357, @subject.total_output_joltage
  end

  def test_lobby_part_2
    @subject = Lobby.new(@part1)

    assert_equal [987654321111,
                  811111111119,
                  434234234278,
                  888911112111], @subject.maximum_joltages_overcoming_static_friction
    assert_equal 3121910778619, @subject.new_total_output_joltage
  end
end
