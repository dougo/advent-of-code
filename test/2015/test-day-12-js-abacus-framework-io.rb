require 'test-helper'
require '2015/day-12-js-abacus-framework-io.rb'

class TestDay12JSAbacusFramework_io < Minitest::Test
  def test_sum_numbers
    # [1,2,3] and {"a":2,"b":4} both have a sum of 6.
    assert_equal 6, Document.new('[1,2,3]').sum_numbers
    assert_equal 6, Document.new('{"a":2,"b":4}').sum_numbers

    # [[[3]]] and {"a":{"b":4},"c":-1} both have a sum of 3.
    assert_equal 3, Document.new('[[[3]]]').sum_numbers
    assert_equal 3, Document.new('{"a":{"b":4},"c":-1}').sum_numbers

    # {"a":[-1,1]} and [-1,{"a":1}] both have a sum of 0.
    assert_equal 0, Document.new('{"a":[-1,1]}').sum_numbers
    assert_equal 0, Document.new('[-1,{"a":1}]').sum_numbers

    # [] and {} both have a sum of 0.
    assert_equal 0, Document.new('[]').sum_numbers
    assert_equal 0, Document.new('{}').sum_numbers
  end

  def test_sum_numbers_ignoring_red
    # [1,2,3] still has a sum of 6.
    assert_equal 6, Document.new('[1,2,3]').sum_numbers_ignoring_red

    # [1,{"c":"red","b":2},3] now has a sum of 4, because the middle object is ignored.
    assert_equal 4, Document.new('[1,{"c":"red","b":2},3]').sum_numbers_ignoring_red

    # {"d":"red","e":[1,2,3,4],"f":5} now has a sum of 0, because the entire structure is ignored.
    assert_equal 0, Document.new('{"d":"red","e":[1,2,3,4],"f":5}').sum_numbers_ignoring_red

    # [1,"red",5] has a sum of 6, because "red" in an array has no effect.
    assert_equal 6, Document.new('[1,"red",5]').sum_numbers_ignoring_red
  end
end
