require 'test-helper'
require '2023/day-17-clumsy-crucible'

class TestClumsyCrucible < Minitest::Test
  def setup
    @subject = ClumsyCrucible.parse <<END
2413432311323
3215453535623
3255245654254
3446585845452
4546657867536
1438598798454
4457876987766
3637877979653
4654967986887
4564679986453
1224686865563
2546548887735
4322674655533
END
    @subject2 = ClumsyCrucible.parse <<END
111111111111
999999999991
999999999991
999999999991
999999999991
END
  end

  def test_minimal_heat_loss
    assert_equal 102, @subject.minimal_heat_loss
  end

  def test_minimal_heat_loss_ultra
    assert_equal 94, @subject.minimal_heat_loss(ultra: true)
    assert_equal 71, @subject2.minimal_heat_loss(ultra: true)
  end
end
