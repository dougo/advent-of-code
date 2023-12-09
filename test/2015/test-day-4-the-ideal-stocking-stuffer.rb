require 'test-helper'
require 'day-4-the-ideal-stocking-stuffer'

class TestDay4TheIdealStockingStuffer < Minitest::Test
  def test_mine_adventcoin
    # If your secret key is abcdef, the answer is 609043, because the MD5 hash of abcdef609043 starts with five
    # zeroes (000001dbbfa...), and it is the lowest such number to do so.
    assert_equal 609043, AdventCoin.new.mine('abcdef')

    # If your secret key is pqrstuv, the lowest number it combines with to make an MD5 hash starting with five
    # zeroes is 1048970; that is, the MD5 hash of pqrstuv1048970 looks like 000006136ef....
    assert_equal 1048970, AdventCoin.new.mine('pqrstuv')

    # Optional second argument is number of zeroes needed.
    refute_equal 1048970, AdventCoin.new.mine('pqrstuv', 3)

    # Note that the result must be positive!
    assert_equal 1, AdventCoin.new.mine('pqrstuv', 0)
  end
end
