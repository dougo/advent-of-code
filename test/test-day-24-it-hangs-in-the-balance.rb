require 'test-helper'
require 'day-24-it-hangs-in-the-balance'

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

  def test_smallest_group_that_weighs
    assert_equal [3], [1,2,3].smallest_group_that_weighs(3)
    assert_equal [1,3], [1,2,3].smallest_group_that_weighs(4)
    assert_equal [1,4], [1,2,3,4].smallest_group_that_weighs(5)
    assert_equal [1,4], [3,4,1,2].smallest_group_that_weighs(5)
    assert_equal [1,6,8], [1,2,3,6,8,10].smallest_group_that_weighs(15)
  end

  def test_ideal_sleigh_configuration
    @subject = [*1..5, *7..11]
    assert_equal [@subject.reverse], @subject.ideal_sleigh_configuration(1)

    conf = @subject.ideal_sleigh_configuration
    assert_equal 99, conf.quantum_entanglement
    assert_equal [[11, 9], [10, 8, 2], [7, 5, 4, 3, 1]], conf

    conf_with_trunk = @subject.ideal_sleigh_configuration(4)
    assert_equal 44, conf_with_trunk.quantum_entanglement
    assert_equal [[11, 4], [10, 5], [8, 7], [9, 3, 2, 1]], conf_with_trunk
  end
end
