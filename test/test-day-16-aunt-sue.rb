require 'test-helper'
require 'day-16-aunt-sue'

class TestDay16AuntSue < Minitest::Test
  def test_aunt_sue
    sue = AuntSue.new('Sue 23: children: 3, akitas: 1, trees: 2')
    assert_equal 23, sue.number
    assert_equal 3, sue.children
    assert_equal 1, sue.akitas
    assert_equal 2, sue.trees
    assert_nil sue.cats
    assert_nil sue.pomeranians
    assert_nil sue.foobar

    sue = AuntSue.new('Sue 42: cats: 5, pomeranians: 0, goldfish: 2')
    assert_equal 42, sue.number
    assert_equal 5, sue.cats
    assert_equal 0, sue.pomeranians
    assert_equal 2, sue.goldfish
    assert_nil sue.children
    assert_nil sue.trees
  end

  def test_parse_list
    sues = AuntSue.parse_list <<END
Sue 37: foo: 1
Sue 88: bar: 2, baz: 3
END
    assert_equal 2, sues.length
    assert_equal 37, sues[0].number
    assert_equal 1, sues[0].foo
    assert_equal 88, sues[1].number
    assert_equal 3, sues[1].baz
  end

  def test_match
    sue = AuntSue.new('Sue 23: foobar: 2, quux: 0')
    assert sue.match?(foobar: 2, quux: 0)
    assert sue.match?(foobar: 2, quux: 0, garply: 3)
    refute sue.match?(foobar: 2, quux: 3)
  end

  def test_list_find_match
    sues = AuntSue.parse_list <<END
Sue 37: foo: 1
Sue 88: bar: 2, baz: 3
END
    assert_equal 37, sues.find_match(foo: 1, bar: 2, baz: 3)
    assert_equal 88, sues.find_match(foo: 0, bar: 2, baz: 3)
  end

  def test_match_retro_encabulator
    ticker = { cats: 2, trees: 3, pomeranians: 4, goldfish: 5, foobar: 1 }
    assert AuntSue.new('Sue 23: cats: 3, trees: 4, pomeranians: 3, goldfish: 4').match_retro_encabulator?(ticker)
    refute AuntSue.new('Sue 23: cats: 2').match_retro_encabulator?(ticker)
    refute AuntSue.new('Sue 23: trees: 3').match_retro_encabulator?(ticker)
    refute AuntSue.new('Sue 23: pomeranians: 4').match_retro_encabulator?(ticker)
    refute AuntSue.new('Sue 23: goldfish: 5').match_retro_encabulator?(ticker)
    assert AuntSue.new('Sue 23: foobar: 1').match_retro_encabulator?(ticker)
  end

  def test_list_find_match_retro_encabulator
    sues = AuntSue.parse_list <<END
Sue 37: cats: 2
Sue 88: bar: 2, baz: 3
END
    assert_equal 37, sues.find_match_retro_encabulator(cats: 1, bar: 2, baz: 3)
    assert_equal 88, sues.find_match_retro_encabulator(cats: 2, bar: 2, baz: 3)
  end
end
