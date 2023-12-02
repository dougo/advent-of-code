require 'test-helper'
require '2023/day-2-cube-conundrum'

class TestCubeGame < Minitest::Test
  def test_sum_of_possible_game_ids
    input = <<END
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
END

    # The Elf would first like to know which games would have been possible if the bag contained
    # only 12 red cubes, 13 green cubes, and 14 blue cubes?
    bag = { red: 12, green: 13, blue: 14 }

    # If you add up the IDs of the games that would have been possible, you get 8.
    assert_equal 8, CubeGame.sum_of_possible_game_ids(input, bag)
  end
end
