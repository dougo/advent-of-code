require 'test-helper'
require '2025/day-02-gift-shop'

class TestGiftShop < Minitest::Test
  def setup
    @part1 = <<END
11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
END
  end

  def test_gift_shop_part_1
    @subject = GiftShop.new(@part1)

    assert_equal [11, 22, 99, 1010, 1188511885, 222222, 446446, 38593859], @subject.invalid_ids
    assert_equal 1227775554, @subject.sum_of_invalid_ids
  end
end
