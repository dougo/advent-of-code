require 'test-helper'
require 'day-24-it-hangs-in-the-balance'

class TestDay24ItHangsInTheBalance < Minitest::Test
  def setup
    @input = <<END
1
2
3
4
5
7
8
9
10
11
END
    @subject = PackageList.parse(@input)
  end

  def test_ideal_configuration
    conf = @subject.ideal_configuration
    assert_equal 99, conf.quantum_entanglement
    assert_equal [[11, 9], [10, 8, 2], [7, 5, 4, 3, 1]], conf

    conf_with_trunk = @subject.ideal_configuration(4)
    assert_equal 44, conf_with_trunk.quantum_entanglement
    assert_equal [[11, 4], [10, 5], [8, 7], [9, 3, 2, 1]], conf_with_trunk
  end
end
