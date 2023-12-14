require 'test-helper'
require '2023/day-3-gear-ratios'

class TestGearRatios < Minitest::Test
  def setup
    @subject = EngineSchematic.new <<END
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
END
  end

  def test_symbol_at
    assert_equal '*', @subject.symbol_at(1, 3)
    assert_equal '#', @subject.symbol_at(3, 6)
    assert_nil @subject.symbol_at(0, 0)
    assert_nil @subject.symbol_at(0, 3)
    assert_nil @subject.symbol_at(-2, 3)
    assert_nil @subject.symbol_at(10, 8)
    assert_nil @subject.symbol_at(3, -4)
    assert_nil @subject.symbol_at(3, 15)
  end

  def test_non_part_number
    number = @subject.number_at(0, 5)
    assert_equal 114, number.value
    refute number.part?
  end

  def test_part_number
    number = @subject.number_at(2, 6)
    assert_equal 633, number.value
    assert number.part?
  end

  def test_adjacent_asterisks
    assert_empty @subject.number_at(2, 6).adjacent_asterisks
    assert_equal [[1, 3]], @subject.number_at(0, 0).adjacent_asterisks
    assert_equal [[0, 1], [0, 5]], EngineSchematic.new('.*123*.').number_at(0, 2).adjacent_asterisks
  end

  def test_numbers
    assert_equal [467, 114, 35, 633, 617, 58, 592, 755, 664, 598],
                 @subject.numbers.map(&:value)
  end

  def test_sum_of_part_numbers
    # In this schematic, two numbers are not part numbers because they are not adjacent to a symbol: 114 (top
    # right) and 58 (middle right). Every other number is adjacent to a symbol and so is a part number; their sum
    # is 4361.
    assert_equal 4361, @subject.sum_of_part_numbers
  end

  def test_symbol_to_left_of_number
    @subject = EngineSchematic.new('*574').numbers.first
    assert_equal 574, @subject.value
    assert @subject.part?
  end

  def test_gears
    # In this schematic, there are two gears. The first is in the top left; it has part numbers 467 and 35, so its
    # gear ratio is 16345. The second gear is in the lower right; its gear ratio is 451490.
    assert_equal [467, 35], @subject.gears.first.part_numbers.map(&:value)
    assert_equal [16345, 451490], @subject.gears.map(&:gear_ratio)
  end

  def test_sum_of_gear_ratios
    # Adding up all of the gear ratios produces # 467835.
    assert_equal 467835, @subject.sum_of_gear_ratios
  end
end
