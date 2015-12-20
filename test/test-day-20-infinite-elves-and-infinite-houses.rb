require 'test-helper'
require 'day-20-infinite-elves-and-infinite-houses'

class TestDay20InfiniteElvesAndInfiniteHouses < Minitest::Test
  def test_delivers_presents_to?
    # The first Elf (number 1) delivers presents to every house: 1, 2, 3, 4, 5, ....
    assert 1.delivers_presents_to?(1)
    assert 1.delivers_presents_to?(2)
    assert 1.delivers_presents_to?(3)

    # The second Elf (number 2) delivers presents to every second house: 2, 4, 6, 8, 10, ....
    assert 2.delivers_presents_to?(2)
    assert 2.delivers_presents_to?(4)
    assert 2.delivers_presents_to?(6)
    refute 2.delivers_presents_to?(1)
    refute 2.delivers_presents_to?(3)

    # Elf number 3 delivers presents to every third house: 3, 6, 9, 12, 15, ....
    assert 3.delivers_presents_to?(3)
    assert 3.delivers_presents_to?(6)
    assert 3.delivers_presents_to?(9)
    refute 3.delivers_presents_to?(1)
    refute 3.delivers_presents_to?(2)
    refute 3.delivers_presents_to?(4)
  end

  def test_elves
    assert_equal [1],          1.elves
    assert_equal [1, 2],       2.elves
    assert_equal [1, 3],       3.elves
    assert_equal [1, 2, 4],    4.elves
    assert_equal [1, 5],       5.elves
    assert_equal [1, 2, 3, 6], 6.elves
    assert_equal [1, 7],       7.elves
    assert_equal [1, 2, 4, 8], 8.elves
    assert_equal [1, 3, 9],    9.elves
  end

  def test_presents
    # House 1 got 10 presents.
    assert_equal 10, 1.presents

    # House 2 got 30 presents.
    assert_equal 30, 2.presents

    # House 3 got 40 presents.
    assert_equal 40, 3.presents

    # House 4 got 70 presents.
    assert_equal 70, 4.presents

    # House 5 got 60 presents.
    assert_equal 60, 5.presents

    # House 6 got 120 presents.
    assert_equal 120, 6.presents

    # House 7 got 80 presents.
    assert_equal 80, 7.presents

    # House 8 got 150 presents.
    assert_equal 150, 8.presents

    # House 9 got 130 presents.
    assert_equal 130, 9.presents
  end

  def test_lowest_house_number_to_get_at_least
    assert_equal 1, lowest_house_number_to_get_at_least(10)
    assert_equal 4, lowest_house_number_to_get_at_least(50)
    assert_equal 6, lowest_house_number_to_get_at_least(100)
    assert_equal 8, lowest_house_number_to_get_at_least(150)
  end
end
