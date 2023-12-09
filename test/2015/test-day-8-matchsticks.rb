require 'test-helper'
require '2015/day-8-matchsticks'

class TestDay8Matchsticks < Minitest::Test
  def setup
    @subject = SantaList.new <<'END'
""
"abc"
"aaa\"aaa"
"\x27"
END
  end

  def test_sizes
    # "" is 2 characters of code (the two double quotes), but the string contains zero characters.
    assert_equal 2, @subject[0].codesize
    assert_equal 0, @subject[0].datasize

    # "abc" is 5 characters of code, but 3 characters in the string data.
    assert_equal 5, @subject[1].codesize
    assert_equal 3, @subject[1].datasize

    # "aaa\"aaa" is 10 characters of code, but the string itself contains six "a" characters and a single, escaped
    # quote character, for a total of 7 characters in the string data.
    assert_equal 10, @subject[2].codesize
    assert_equal  7, @subject[2].datasize

    # "\x27" is 6 characters of code, but the string itself contains just one - an apostrophe ('), escaped using
    # hexadecimal notation.
    assert_equal 6, @subject[3].codesize
    assert_equal 1, @subject[3].datasize

    # For example, given the four strings above, the total number of characters of string code (2 + 5 + 10 + 6 =
    # 23) minus the total number of characters in memory for string values (0 + 3 + 7 + 1 = 11) is 23 - 11 = 12.
    assert_equal 12, @subject.sizediff
  end

  def test_encodedsize
    # "" encodes to "\"\"", an increase from 2 characters to 6.
    assert_equal 6, @subject[0].encodedsize

    # "abc" encodes to "\"abc\"", an increase from 5 characters to 9.
    assert_equal 9, @subject[1].encodedsize

    # "aaa\"aaa" encodes to "\"aaa\\\"aaa\"", an increase from 10 characters to 16.
    assert_equal 16, @subject[2].encodedsize

    # "\x27" encodes to "\"\\x27\"", an increase from 6 characters to 11.
    assert_equal 11, @subject[3].encodedsize

    # For example, for the strings above, the total encoded length (6 + 9 + 16 + 11 = 42) minus the characters in
    # the original code representation (23, just like in the first part of this puzzle) is 42 - 23 = 19.
    assert_equal 19, @subject.encoded_sizediff
  end
end
