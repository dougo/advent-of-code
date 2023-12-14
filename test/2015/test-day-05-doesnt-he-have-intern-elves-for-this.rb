require 'test-helper'
require '2015/day-05-doesnt-he-have-intern-elves-for-this'

class TestDay5 < Minitest::Test
  def setup
    @subject = Santa.new
    @input = <<END
ugknbfddgicrmopn
aaa
jchzalrnumimnmhp
haegwjzuvuyypxyu
dvszwmarrgswjxmb
END
    @new_input = <<END
qjhvhtzxzqqjkmpb
xxyxx
uurcxstgmygtbstg
ieodomkazucvgmuy
END
  end

  def test_nice?
    input = @input.split

    # ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and
    # none of the disallowed substrings.
    assert @subject.nice? input[0]

    # aaa is nice because it has at least three vowels and a double letter, even though the letters used by
    # different rules overlap.
    assert @subject.nice? input[1]

    # jchzalrnumimnmhp is naughty because it has no double letter.
    refute @subject.nice? input[2]

    # haegwjzuvuyypxyu is naughty because it contains the string xy.
    refute @subject.nice? input[3]

    # dvszwmarrgswjxmb is naughty because it contains only one vowel.
    refute @subject.nice? input[4]
  end

  def test_num_nice
    assert_equal 2, @subject.num_nice(@input)
  end


  def test_new_nice?
    new_input = @new_input.split

    # qjhvhtzxzqqjkmpb is nice because is has a pair that appears twice (qj) and a letter that repeats with exactly
    # one letter between them (zxz).
    assert @subject.new_nice?(new_input[0])

    # xxyxx is nice because it has a pair that appears twice and a letter that repeats with one between, even though
    # the letters used by each rule overlap.
    assert @subject.new_nice?(new_input[1])

    # uurcxstgmygtbstg is naughty because it has a pair (tg) but no repeat with a single letter between them.
    refute @subject.new_nice?(new_input[2])

    # ieodomkazucvgmuy is naughty because it has a repeating letter with one between (odo), but no pair that appears
    # twice.
    refute @subject.new_nice?(new_input[3])
  end

  def test_num_new_nice
    assert_equal 2, @subject.num_new_nice(@new_input)
  end
end
