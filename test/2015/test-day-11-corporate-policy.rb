require 'test-helper'
require '2015/day-11-corporate-policy'

class TestDay11CorporatePolicy < Minitest::Test
  def setup
    @subject = SecurityElf.new
  end

  def test_next_password
    # hijklmmn meets the first requirement (because it contains the straight hij) but fails the second requirement
    # requirement (because it contains i and l).
    assert @subject.has_straight?('hijklmmn')
    refute @subject.has_no_confusing?('hijklmmn')

    # abbceffg meets the third requirement (because it repeats bb and ff) but fails the first requirement.
    assert @subject.has_two_pairs?('abbceffg')
    refute @subject.has_straight?('abbceffg')

    # abbcegjk fails the third requirement, because it only has one double letter (bb).
    refute @subject.has_straight?('abbcegjk')

    # The next password after abcdefgh is abcdffaa.
    assert_equal 'abcdffaa', @subject.next_password('abcdefgh')

    # The next password after ghijklmn is ghjaabcc, because you eventually skip all the passwords that start with
    # ghi..., since i is not allowed.
    assert_equal 'ghjaabcc', @subject.next_password('ghijklmn')


    # Make sure the old password isn't just returned if it's already valid!
    assert_equal 'ghjbbcdd', @subject.next_password('ghjaabcc')

    refute @subject.has_two_pairs?('aaaa'), 'Pairs must be different!'
  end
end
