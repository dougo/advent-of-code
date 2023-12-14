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
    @subject = HotSprings.new(@input)
  end

  def test_distributions
    assert_equal [[0, 2], [1, 1], [2, 0]], ConditionRecord.distributions(2, 2)
    assert_equal [[0, 0, 2], [0, 1, 1], [0, 2, 0], [1, 0, 1], [1, 1, 0], [2, 0, 0]],
                 ConditionRecord.distributions(2, 3)
  end

  def test_all_arrangements
    assert_equal ['##..', '.##.', '..##'], ConditionRecord.all_arrangements(4, [2])
    assert_equal ['#.#..', '#..#.', '#...#', '.#.#.', '.#..#', '..#.#'],
                 ConditionRecord.all_arrangements(5, [1, 1])
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
end
