require 'test-helper'
require 'day-9-all-in-a-single-night'

class TestDay9AllInASingleNight < Minitest::Test
  def setup
    @input = <<END
London to Dublin = 464
London to Belfast = 518
Dublin to Belfast = 141
END
    @map = SantaMap.new(@input)
  end

  def test_routes
    expected_routes = {
      %w(Dublin London Belfast) => 982,
      %w(London Dublin Belfast) => 605,
      %w(London Belfast Dublin) => 659,
      %w(Dublin Belfast London) => 659,
      %w(Belfast Dublin London) => 605,
      %w(Belfast London Dublin) => 982
    }

    assert_equal expected_routes.keys.to_set, @map.routes.to_set

    expected_routes.each do |route, distance|
      assert_equal distance, @map.route_distance(route)
    end
  end

  def test_shortest_route
    # The shortest of these is London -> Dublin -> Belfast = 605, and so the answer is 605 in this example.
    route = @map.shortest_route
    assert_equal %w(London Dublin Belfast), route
    assert_equal 605, @map.route_distance(route)
  end

  def test_longest_route
    # For example, given the distances above, the longest route would be 982 via (for example) Dublin -> London ->
    # Belfast.
    expected_route = %w(Dublin London Belfast)
    route = @map.longest_route
    assert_includes [expected_route, expected_route.reverse], route
    assert_equal 982, @map.route_distance(route)
  end
end
