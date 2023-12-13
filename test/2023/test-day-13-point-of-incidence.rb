require 'test-helper'
require '2023/day-13-point-of-incidence'

class TestValleyOfMirrors < Minitest::Test
  def setup
    @subject = ValleyOfMirrors.parse <<END
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
END
  end
  
  def test_rows_above_mirror
    assert_nil @subject.patterns[0].rows_above_mirror
    assert_equal 4, @subject.patterns[1].rows_above_mirror
  end

  def test_cols_left_of_mirror
    assert_equal 5, @subject.patterns[0].cols_left_of_mirror
    assert_nil @subject.patterns[1].cols_left_of_mirror
  end

  def test_summarize_pattern_notes
    assert_equal 405, @subject.summarize_pattern_notes
  end
end
