require 'test-helper'
require '2023/day-16-the-floor-will-be-lava'

class TestMirrorContraption < Minitest::Test
  def setup
    @subject = MirrorContraption.parse <<END
.|...\\....
|.-.\\.....
.....|-...
........|.
..........
.........\\
..../.\\\\..
.-.-/..|..
.|....-|.\\
..//.|....
END
  end

  def test_show_tiles_energized
    expected_text = <<END
######....
.#...#....
.#...#####
.#...##...
.#...##...
.#...##...
.#..####..
########..
.#######..
.#...#.#..
END
    expected = expected_text.lines(chomp: true)
    assert_equal expected, @subject.show_tiles_energized
  end

  def test_num_tiles_energized
    assert_equal 46, @subject.num_tiles_energized
  end

  def test_max_tiles_energized
    assert_equal 51, @subject.max_tiles_energized
  end
end
