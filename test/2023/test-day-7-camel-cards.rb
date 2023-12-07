require 'test-helper'
require '2023/day-7-camel-cards'

class TestCamelCards < Minitest::Test
  def setup
    @input = <<END
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
END
    @subject = CamelCards.new(@input)
  end

  def test_hand_type
    # - Five of a kind, where all five cards have the same label: AAAAA
    # - Four of a kind, where four cards have the same label and one card has a different label: AA8AA
    # - Full house, where three cards have the same label, and the remaining two cards share a different label:
    #   23332
    # - Three of a kind, where three cards have the same label, and the remaining two cards are each different from
    #   any other card in the hand: TTT98
    # - Two pair, where two cards share one label, two other cards share a second label, and the remaining card has
    #   a third label: 23432
    # - One pair, where two cards share one label, and the other three cards have a different label from the pair
    #   and each other: A23A4
    # - High card, where all cards' labels are distinct: 23456
    assert_equal :five_of_a_kind, CamelCards::Hand.new('AAAAA').type
    assert_equal :four_of_a_kind, CamelCards::Hand.new('AA8AA').type
    assert_equal :full_house, CamelCards::Hand.new('23332').type
    assert_equal :full_house, CamelCards::Hand.new('32223').type
    assert_equal :three_of_a_kind, CamelCards::Hand.new('TTT98').type
    assert_equal :two_pair, CamelCards::Hand.new('23432').type
    assert_equal :two_pair, CamelCards::Hand.new('J2J28').type
    assert_equal :one_pair, CamelCards::Hand.new('A23A4').type
    assert_equal :high_card, CamelCards::Hand.new('23456').type
  end

  def test_sort_value
    assert_equal [3, [4, 4, 4, 5, 6]], CamelCards::Hand.new('TTT98').sort_value
  end

  def test_ranked_bids
    assert_equal [765, 220, 28, 684, 483], @subject.ranked_bids
  end

  def test_total_winnings
    # So the total winnings in this example are 6440.
    assert_equal 6440, @subject.total_winnings
  end
end
