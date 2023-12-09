require 'test-helper'
require '2015/day-24-it-hangs-in-the-balance'

class TestDay24ItHangsInTheBalance < Minitest::Test
  def test_parse_package_weights
    input = <<END
1
2
3
END
    assert_equal (1..3).to_a, input.parse_package_weights
  end

  def test_each_group_by_size
    assert_equal [[1], [2], [3], [1,2], [1,3], [2,3], [1,2,3]], [1,2,3].each_group_by_size.to_a
  end

  def test_each_group_that_weighs
    assert_equal [[3], [1,2]], [1,2,3].each_group_that_weighs(3).to_a
    assert_equal [[1,4], [2,3]], [1,2,3,4].each_group_that_weighs(5).to_a
  end

  def test_smallest_groups_that_weigh
    assert_equal [[3]], [1,2,3].smallest_groups_that_weigh(3)
    assert_equal [[1,4], [2,3]], [1,2,3,4].smallest_groups_that_weigh(5)
    assert_equal [[3,2], [4,1]], [3,4,1,2].smallest_groups_that_weigh(5)
    assert_equal [[10,3,2], [8,6,1]], [10,8,6,3,2,1].smallest_groups_that_weigh(15)
    assert_equal [[1,9,11], [2,3,16]], [1,2,3,9,11,16].smallest_groups_that_weigh(21)
  end

  def test_smallest_group_that_weighs
    assert_equal [3], [1,2,3].smallest_group_that_weighs(3)
    assert_equal [1,3], [1,2,3].smallest_group_that_weighs(4)
    assert_equal [1,4], [1,2,3,4].smallest_group_that_weighs(5)
    assert_equal [1,4], [3,4,1,2].smallest_group_that_weighs(5)
    assert_equal [1,6,8], [10,8,6,3,2,1].smallest_group_that_weighs(15)
    assert_equal [2,3,16], [1,2,3,9,11,16].smallest_group_that_weighs(21)
    assert_equal [2,3,16], [1,2,3,6,7,8,9,11,16].smallest_group_that_weighs(21)
  end

  def test_ideal_sleigh_configuration
    @subject = [*1..5, *7..11]
    assert_equal [@subject.reverse], @subject.ideal_sleigh_configuration(1)

    # Examples from the problem statement:

    # 11 9       (QE= 99); 10 8 2;  7 5 4 3 1
    conf = @subject.ideal_sleigh_configuration
    assert_equal 99, conf.quantum_entanglement
    assert_equal [[11, 9], [10, 8, 2], [7, 5, 4, 3, 1]], conf

    # 11 4    (QE=44); 10 5;   9 3 2 1; 8 7
    conf_with_trunk = @subject.ideal_sleigh_configuration(4)
    assert_equal 44, conf_with_trunk.quantum_entanglement
    assert_equal [[11, 4], [10, 5], [8, 7], [9, 3, 2, 1]], conf_with_trunk

    # Counterexamples showing that the first smallest group does not always have the lowest QE:

    counterexample_conf = [1,2,3,6,7,8,9,11,16].ideal_sleigh_configuration
    assert_equal 96, counterexample_conf.quantum_entanglement
    assert_equal [[16,3,2], [11,9,1], [8,7,6]], counterexample_conf

    primes_conf = [1,3,5,13,17,23,31,37,53].ideal_sleigh_configuration
    assert_equal 795, primes_conf.quantum_entanglement
    assert_equal [[53,5,3], [37,23,1], [31,17,13]], primes_conf
  end
end
