require 'test-helper'
require '2025/day-01-secret-entrance'

class TestSecretEntrance < Minitest::Test
  def setup
    @part1 = <<END
L68
L30
R48
L5
R60
L55
L1
L99
R14
L82
END
  end

  def test_safe_part_1
    @subject = Safe.new(@part1)

    assert_equal [50, 82, 52, 0, 95, 55, 0, 99, 0, 14, 32], @subject.dial_locations

    assert_equal 3, @subject.password
  end
end
