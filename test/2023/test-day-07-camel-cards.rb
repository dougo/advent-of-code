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
    @subject2 = CamelCards.new(@input, with_jokers: true)
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
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('AAAAA').type
    assert_equal :four_of_a_kind,  CamelCards::Hand.new('AA8AA').type
    assert_equal :full_house,      CamelCards::Hand.new('23332').type
    assert_equal :full_house,      CamelCards::Hand.new('32223').type
    assert_equal :three_of_a_kind, CamelCards::Hand.new('TTT98').type
    assert_equal :two_pair,        CamelCards::Hand.new('23432').type
    assert_equal :two_pair,        CamelCards::Hand.new('J2J28').type
    assert_equal :one_pair,        CamelCards::Hand.new('A23A4').type
    assert_equal :high_card,       CamelCards::Hand.new('23456').type
  end

  def test_sort_value
    assert_equal [3, [4, 4, 4, 0, 6]], CamelCards::Hand.new('TTTA8').sort_value
  end

  def test_ranked_bids
    assert_equal [765, 220, 28, 684, 483], @subject.ranked_bids
  end

  def test_total_winnings
    # So the total winnings in this example are 6440.
    assert_equal 6440, @subject.total_winnings
  end

  def test_hand_type_with_jokers
    # - 32T3K is still the only one pair; it doesn't contain any jokers, so its strength doesn't increase.
    # - KK677 is now the only two pair, making it the second-weakest hand.
    # - T55J5, KTJJT, and QQQJA are now all four of a kind!
    assert_equal %i(one_pair four_of_a_kind two_pair four_of_a_kind four_of_a_kind),
                 @subject2.hands.map(&:type)
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('AAAAJ', 0, true).type
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('AAAJJ', 0, true).type
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('AAJJJ', 0, true).type
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('AJJJJ', 0, true).type
    assert_equal :five_of_a_kind,  CamelCards::Hand.new('JJJJJ', 0, true).type
    assert_equal :four_of_a_kind,  CamelCards::Hand.new('AQJJJ', 0, true).type
    assert_equal :full_house,      CamelCards::Hand.new('AAQQJ', 0, true).type
    assert_equal :three_of_a_kind, CamelCards::Hand.new('AAKQJ', 0, true).type
    assert_equal :three_of_a_kind, CamelCards::Hand.new('AKQJJ', 0, true).type
    assert_equal :one_pair,        CamelCards::Hand.new('AKQTJ', 0, true).type
  end

  def test_sort_value_with_jokers
    assert_equal [3, [12, 3, 3, 0, 5]], CamelCards::Hand.new('JTTA8', 0, true).sort_value
  end

  def test_ranked_bids_with_jokers
    # T55J5 gets rank 3, QQQJA gets rank 4, and KTJJT gets rank 5.
    assert_equal [765, 28, 684, 483, 220], @subject2.ranked_bids
  end

  def test_total_winnings_with_jokers
    # With the new joker rule, the total winnings in this example are 5905.
    assert_equal 5905, @subject2.total_winnings
  end
end
