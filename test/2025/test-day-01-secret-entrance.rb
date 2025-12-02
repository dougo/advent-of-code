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

  def test_safe_part_2
    @subject = Safe.new(@part1)

    assert_equal 6, @subject.password(0x434C49434B)
  end

  def test_rotate_right_passes_zero_multiple_times
    @subject = Safe.new <<END
R1000
END
    assert_equal 10, @subject.password(0x434C49434B)
  end

  def test_rotate_left_passes_zero_multiple_times
    @subject = Safe.new <<END
L500
END
    assert_equal 5, @subject.password(0x434C49434B)
  end

  def test_rotate_left_starting_at_zero_passes_zero_multiple_times
    @subject = Safe.new <<END
L50
L250
END
    # points at zero, then passes it twice
    assert_equal 3, @subject.password(0x434C49434B)
  end

  def test_rotate_left_starting_at_zero_passes_zero_multiple_times_ending_at_zero
    @subject = Safe.new <<END
L50
L300
END
    # points at zero, then passes it twice, then ends at zero
    assert_equal 4, @subject.password(0x434C49434B)
  end
end
