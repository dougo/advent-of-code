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

  def test_lobby
    @subject = Lobby.new(@part1)

    assert_equal [98, 89, 78, 92], @subject.maximum_joltages
    assert_equal 357, @subject.total_output_joltage
  end
end
