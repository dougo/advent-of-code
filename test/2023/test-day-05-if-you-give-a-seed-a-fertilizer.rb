require 'test-helper'
require '2023/day-5-if-you-give-a-seed-a-fertilizer'

class TestAlmanac < Minitest::Test
  def test_range_intersection
    assert_equal 2..4, (1..4) & (2..5)
    assert_equal 2..4, (2..5) & (1..4)
    assert_equal 2..4, (1...5) & (2...6)
    assert_equal 2..4, (1..4) & (2..)
    assert_empty ((1..2) & (4..5)).to_a
  end

  def test_range_increment
    assert_equal 2..4, (1..3).increment(1)
    assert_equal 2..3, (1...3).increment(1)
  end

  def setup
    @subject = Almanac.new <<END
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
END
  end

  def test_map_convert
    map = @subject.maps.first
    # With this map, you can look up the soil number required for each initial seed number:
    # Seed number 79 corresponds to soil number 81.
    # Seed number 14 corresponds to soil number 14.
    # Seed number 55 corresponds to soil number 57.
    # Seed number 13 corresponds to soil number 13.
    assert_equal 81, map.convert(79)
    assert_equal 14, map.convert(14)
    assert_equal 57, map.convert(55)
    assert_equal 13, map.convert(13)
  end

  def test_zero_conversions_in_gaps
    map = Almanac::Map.new <<END
seed-to-soil map:
10 5 5
20 15 5
END
    assert_equal 3, map.convert(3)
    assert_equal 13, map.convert(13)
    assert_equal 23, map.convert(23)
  end

  def test_seed_conversions
    # Seed 79, soil 81, fertilizer 81, water 81, light 74, temperature 78, humidity 78, location 82.
    # Seed 14, soil 14, fertilizer 53, water 49, light 42, temperature 42, humidity 43, location 43.
    # Seed 55, soil 57, fertilizer 57, water 53, light 46, temperature 82, humidity 82, location 86.
    # Seed 13, soil 13, fertilizer 52, water 41, light 34, temperature 34, humidity 35, location 35.
    assert_equal [79, 81, 81, 81, 74, 78, 78, 82], @subject.seed_conversions(79)
    assert_equal [14, 14, 53, 49, 42, 42, 43, 43], @subject.seed_conversions(14)
    assert_equal [55, 57, 57, 53, 46, 82, 82, 86], @subject.seed_conversions(55)
    assert_equal [13, 13, 52, 41, 34, 34, 35, 35], @subject.seed_conversions(13)
  end

  def test_seed_locations
    assert_equal [82, 43, 86, 35], @subject.seed_locations
  end

  def test_lowest_seed_location
    # So, the lowest location number in this example is 35.
    assert_equal 35, @subject.lowest_seed_location
  end

  def test_seed_ranges
    # The first range starts with seed number 79 and contains 14 values: 79, 80, ..., 91, 92.
    # The second range starts with seed number 55 and contains 13 values: 55, 56, ..., 66, 67.
    assert_equal [(79..92).to_a, (55..67).to_a], # convert to arrays because [79..92] != [79...93], weirdly!
                 @subject.seed_ranges.map(&:to_a)
  end

  def test_map_convert_range
    map = @subject.maps.first
    assert_equal [81..94], map.convert_range(79..92)
    assert_equal [50..51, 97..99], map.convert_range(95..99)
    assert_equal [50..51, 52..99, 48..49, 100..101], map.convert_range(48..101)
  end

  def test_lowest_seed_location_in_ranges
    # So, the lowest location number is 46.
    assert_equal 46, @subject.lowest_seed_location_in_ranges
  end
end
