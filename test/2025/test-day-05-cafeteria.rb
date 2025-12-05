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

  def test_available_fresh_ingredient_ids
    assert_equal [5, 11, 17], @subject.available_fresh_ingredient_ids
  end

  def test_num_available_fresh_ingredients
    assert_equal 3, @subject.num_available_fresh_ingredients
  end

  def test_fresh_ingredient_ids
    assert_equal [3, 4, 5, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20], @subject.fresh_ingredient_ids
  end

  def test_num_fresh_ingredients
    assert_equal 14, @subject.num_fresh_ingredients
  end
end
