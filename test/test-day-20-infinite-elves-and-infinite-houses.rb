require 'test-helper'
require 'day-20-infinite-elves-and-infinite-houses'

class TestDay20InfiniteElvesAndInfiniteHouses < Minitest::Test
  def test_elves
    # The first house ... is visited only by Elf 1
    assert_equal [1],          1.elves
    assert_equal [1, 2],       2.elves
    assert_equal [1, 3],       3.elves
    # The fourth house ... is visited by Elves 1, 2, and 4
    assert_equal [1, 2, 4],    4.elves
    assert_equal [1, 5],       5.elves
    assert_equal [1, 2, 3, 6], 6.elves
    assert_equal [1, 7],       7.elves
    assert_equal [1, 2, 4, 8], 8.elves
    assert_equal [1, 3, 9],    9.elves
  end

  def test_presents
    # House 1 got 10 presents.
    # House 2 got 30 presents.
    # House 3 got 40 presents.
    # House 4 got 70 presents.
    # House 5 got 60 presents.
    # House 6 got 120 presents.
    # House 7 got 80 presents.
    # House 8 got 150 presents.
    # House 9 got 130 presents.
    [10, 30, 40, 70, 60, 120, 80, 150, 130].each_with_index do |expected_presents, i|
      assert_equal expected_presents, (i+1).presents
    end
  end

  def test_lowest_house_number_to_get_at_least
    assert_equal 1, lowest_house_number_to_get_at_least(10)
    assert_equal 4, lowest_house_number_to_get_at_least(50)
    assert_equal 6, lowest_house_number_to_get_at_least(100)
    assert_equal 8, lowest_house_number_to_get_at_least(150)
  end
end
