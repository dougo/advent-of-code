require 'test-helper'
require 'util'

class TestUtil < Minitest::Test
  def test_index_by
    assert_equal({}, [].index_by {})
    assert_equal({ 1 => 1, 2 => 2 }, [1, 2].index_by { |x| x })
    assert_equal({ 1 => 1, 2 => 2 }, (1..2).index_by { |x| x })    
    assert_equal({ 1 => 1, 2 => 2 }, [1, 2, 1].index_by { |x| x })
    assert_equal({ a: 'a', b: 'b' }, %w(a b b).index_by(&:to_sym))
  end

  def test_sum
    assert_equal 0, [].sum
    assert_equal 0, [].sum { }
    assert_equal 1, [1].sum
    assert_equal 3, (1..2).sum
    assert_equal 7, (1..2).sum { |x| x + 2 }
    assert_equal 11, %w(one two three).sum(&:length)
  end

  def test_in?
    assert 2.in?(1..3)
    assert 'b'.in?(%w(a b c))
    refute 'x'.in?(%w(a b c))
  end
end
