require 'test-helper'
require '2025/day-05-cafeteria'

class TestCafeteria < Minitest::Test
  def setup
    @input = <<END
3-5
10-14
16-20
12-18

1
5
8
11
17
32
END
    @subject = Cafeteria.parse(@input)
  end

  def test_fresh_ingredient_ids
    assert_equal [5, 11, 17], @subject.fresh_ingredient_ids
  end

  def test_num_fresh_ingredient_ids
    assert_equal 3, @subject.num_fresh_ingredient_ids
  end
end
