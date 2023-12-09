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

    assert_equal [1, 2, 4, 8, 16],      16.elves
    assert_equal [1, 2, 5, 10, 25, 50], 50.elves
    assert_equal [1, 3, 17, 51],        51.elves
  end

  def test_lazy_elves
    # If elves stop after 3 houses each, then:
    #  - Elf 1 will visit houses 1, 2, 3.
    #  - Elf 2 will visit houses 2, 4, 6.
    #  - Elf 4 will visit houses 4, 8, 12.
    #  - Elf 8 will visit houses 8, 16, 24.
    #  - Elf 16 will visit houses 16, 32, 48.
    assert_equal [1, 2], 2.elves(max_houses_per_elf: 3)
    assert_equal [2, 4], 4.elves(max_houses_per_elf: 3) # Elf 1 stops before house 4.
    assert_equal [4, 8], 8.elves(max_houses_per_elf: 3) # Elves 1 and 2 stop before house 8.
    assert_equal [8, 16], 16.elves(max_houses_per_elf: 3) # Elves 1, 2, and 4 stop before house 16.

    assert_equal [1, 2, 5, 10, 25, 50], 50.elves(max_houses_per_elf: 50)
    assert_equal [3, 17, 51],           51.elves(max_houses_per_elf: 50) # Elf 1 stopped after house 50.
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

  def test_presents_from_lazy_elves
    # If elves stop after 3 houses each but deliver 11 presents each, then
    #  - House 16 gets 11 presents each from elves 8 and 16, i.e. 11 * (8+16) = 264.
    assert_equal 264, 16.presents(max_houses_per_elf: 3, presents_per_elf: 11)
  end

  def test_lowest_house_number_to_get_at_least
    assert_equal 1, lowest_house_number_to_get_at_least(10)
    assert_equal 4, lowest_house_number_to_get_at_least(50)
    assert_equal 6, lowest_house_number_to_get_at_least(100)
    assert_equal 8, lowest_house_number_to_get_at_least(150)

    assert_equal 16, lowest_house_number_to_get_at_least(264, max_houses_per_elf: 3, presents_per_elf: 11)
  end
end
