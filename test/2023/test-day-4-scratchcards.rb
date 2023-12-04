require 'test-helper'
require '2023/day-4-scratchcards'

class TestScratchcards < Minitest::Test
  def setup
    @subject = Scratchcards.new <<END
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
END
  end
  
  def test_cards
    # In the above example, card 1 has five winning numbers (41, 48, 83, 86, and 17) and eight numbers you have
    # (83, 86, 6, 31, 17, 9, 48, and 53).
    assert_equal [41, 48, 83, 86, 17], @subject.cards.first.winning_numbers
    assert_equal [83, 86, 6, 31, 17, 9, 48, 53], @subject.cards.first.your_numbers
  end

  def test_points
    # Of the numbers you have, four of them (48, 83, 17, and 86) are winning numbers! That means card 1 is worth 8
    # points (1 for the first match, then doubled three times for each of the three matches after the first).
    # Card 2 has two winning numbers (32 and 61), so it is worth 2 points.
    # Card 3 has two winning numbers (1 and 21), so it is worth 2 points.
    # Card 4 has one winning number (84), so it is worth 1 point.
    # Card 5 has no winning numbers, so it is worth no points.
    # Card 6 has no winning numbers, so it is worth no points.
    assert_equal [8, 2, 2, 1, 0, 0], @subject.points
  end

  def test_total_points
    # So, in this example, the Elf's pile of scratchcards is worth 13 points.
    assert_equal 13, @subject.total_points
  end
end
