require 'test-helper'
require '2023/day-23-a-long-walk'

class TestALongWalk < Minitest::Test
  def setup
    @input = <<END
#.#####################
#.......#########...###
#######.#########.#.###
###.....#.>.>.###.#.###
###v#####.#v#.###.#.###
###.>...#.#.#.....#...#
###v###.#.#.#########.#
###...#.#.#.......#...#
#####.#.#.#######.#.###
#.....#.#.#.......#...#
#.#####.#.#.#########v#
#.#...#...#...###...>.#
#.#.#v#######v###.###v#
#...#.>.#...>.>.#.###.#
#####v#.#.###v#.#.###.#
#.....#...#...#.#.#...#
#.#########.###.#.#.###
#...###...#...#...#.###
###.###.#.###v#####v###
#...#...#.#.>.>.#.>.###
#.###.###.#.###.#.#v###
#.....###...###...#...#
#####################.#
END
    @subject = ALongWalk.parse(@input)
  end

  def test_longest_hike_steps
    assert_equal 94, @subject.longest_hike_steps
    assert_equal 154, @subject.longest_hike_steps(dry: true)
  end

  def test_next_node
    assert_equal [Position[5,3], 15], @subject.next_node(Position[0,1])
    assert_equal [Position[13,5], 21], @subject.next_node(Position[6,3])
    assert_equal [Position[3,11], 21], @subject.next_node(Position[5,4])
    assert_equal [Position[22,21], 4], @subject.next_node(Position[20,19])
  end

  Edge = ALongWalk::Edge

  def test_to_graph
    graph = @subject.to_graph
    assert_includes graph.edges, Edge[Position[0,1], 15, Position[5,3]]
    assert_includes graph.edges, Edge[Position[5,3], 22, Position[13,5]]
    assert_includes graph.edges, Edge[Position[5,3], 22, Position[3,11]]
    assert_includes graph.edges, Edge[Position[13,5], 38, Position[19,13]]
    assert_includes graph.edges, Edge[Position[19,19], 5, Position[22,21]]
    assert_equal 12, graph.edges.length
  end
end
