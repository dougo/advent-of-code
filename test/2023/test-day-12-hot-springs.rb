require 'test-helper'
require '2023/day-12-hot-springs'

class TestHotSprings < Minitest::Test
  def setup
    @input = <<END
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
END
    @subject = HotSprings.parse(@input)
  end

  def test_arrangements
    expected = <<END
.###.##.#...
.###.##..#..
.###.##...#.
.###.##....#
.###..##.#..
.###..##..#.
.###..##...#
.###...##.#.
.###...##..#
.###....##.#
END
    assert_equal expected.lines(chomp: true), @subject.conditions.last.arrangements
  end

  def test_number_of_arrangements
    assert_equal 1, @subject.conditions[0].number_of_arrangements
    assert_equal 4, @subject.conditions[1].number_of_arrangements
    assert_equal 1, @subject.conditions[2].number_of_arrangements
    assert_equal 1, @subject.conditions[3].number_of_arrangements
    assert_equal 4, @subject.conditions[4].number_of_arrangements
    assert_equal 10, @subject.conditions[5].number_of_arrangements
  end

  def test_sum_of_number_of_arrangements
    assert_equal 21, @subject.sum_of_number_of_arrangements
  end

  def test_unfold
    unfolded = @subject.unfold
    cond = unfolded.conditions.first
    assert_equal '???.###????.###????.###????.###????.###', cond.pattern
    assert_equal [1,1,3,1,1,3,1,1,3,1,1,3,1,1,3], cond.groups

    assert_equal 1, unfolded.conditions[0].number_of_arrangements
    assert_equal 16384, unfolded.conditions[1].number_of_arrangements
    assert_equal 1, unfolded.conditions[2].number_of_arrangements
    assert_equal 16, unfolded.conditions[3].number_of_arrangements
    assert_equal 2500, unfolded.conditions[4].number_of_arrangements
    assert_equal 506250, unfolded.conditions[5].number_of_arrangements
  end
end
