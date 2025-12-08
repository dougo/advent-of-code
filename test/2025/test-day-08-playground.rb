require 'test-helper'
require '2025/day-08-playground'

class TestPlayground < Minitest::Test
  def setup
    @input = <<END
162,817,812
57,618,57
906,360,560
592,479,940
352,342,300
466,668,158
542,29,236
431,825,988
739,650,466
52,470,668
216,146,977
819,987,18
117,168,530
805,96,715
346,949,466
970,615,88
941,993,340
862,61,35
984,92,344
425,690,689
END
    @subject = Playground.parse(@input)
    @p1 = Position3D[162,817,812]
    @p2 = Position3D[425,690,689]
    @p3 = Position3D[431,825,988]
  end

  attr :p1, :p2, :p3

  def test_connect_closest_unconnected_pair!
    assert_equal Set[p1, p2], @subject.unconnected_pairs.first.positions
    refute @subject.connected?(p1, p2)
    @subject.connect_closest_unconnected_pair!
    assert @subject.connected?(p1, p2)
    assert_equal Set[p1, p3], @subject.unconnected_pairs.first.positions
  end

  def test_circuit_sizes
    @subject.connect_closest_pairs!(10)
    assert_equal [5, 4, 2, 2, 1, 1, 1, 1, 1, 1, 1], @subject.circuit_sizes
  end

  def test_product_of_three_largest_circuit_sizes
    @subject.connect_closest_pairs!(10)
    assert_equal 40, @subject.product_of_three_largest_circuit_sizes
  end
end
