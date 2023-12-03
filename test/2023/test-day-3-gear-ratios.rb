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

  def test_symbol_at?
    assert @subject.symbol_at?(1, 3)
    refute @subject.symbol_at?(0, 0)
    refute @subject.symbol_at?(0, 3)
    refute @subject.symbol_at?(-2, 3)
    refute @subject.symbol_at?(10, 8)
    refute @subject.symbol_at?(3, -4)
    refute @subject.symbol_at?(3, 15)
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
end
