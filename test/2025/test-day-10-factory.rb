require 'test-helper'
require '2025/day-10-factory'

class TestFactory < Minitest::Test
  def setup
    @input = <<END
[.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
[...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
[.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
END
    @subject = Factory.parse(@input)
  end

  def test_fewest_button_presses
    assert_equal 7, @subject.fewest_button_presses
  end

  def test_fewest_button_presses_for_joltage
    assert_equal 33, @subject.fewest_button_presses(for_joltage: true)
  end
end
