=begin

--- Day 2: Cube Conundrum ---

You're launched high into the atmosphere! The apex of your trajectory just barely reaches the surface of a large
island floating in the sky. You gently land in a fluffy pile of leaves. It's quite cold, but you don't see much
snow. An Elf runs over to greet you.

The Elf explains that you've arrived at Snow Island and apologizes for the lack of snow. He'll be happy to explain
the situation, but it's a bit of a walk, so you have some time. They don't get many visitors up here; would you
like to play a game in the meantime?

As you walk, the Elf shows you a small bag and some cubes which are either red, green, or blue. Each time you play
this game, he will hide a secret number of cubes of each color in the bag, and your goal is to figure out
information about the number of cubes.

To get information, once a bag has been loaded with cubes, the Elf will reach into the bag, grab a handful of
random cubes, show them to you, and then put them back in the bag. He'll do this a few times per game.

You play several games and record the information from each game (your puzzle input). Each game is listed with its
ID number (like the 11 in Game 11: ...) followed by a semicolon-separated list of subsets of cubes that were
revealed from the bag (like 3 red, 5 green, 4 blue).

For example, the record of a few games might look like this:

Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green

In game 1, three sets of cubes are revealed from the bag (and then put back again). The first set is 3 blue cubes
and 4 red cubes; the second set is 1 red cube, 2 green cubes, and 6 blue cubes; the third set is only 2 green
cubes.

The Elf would first like to know which games would have been possible if the bag contained only 12 red cubes, 13
green cubes, and 14 blue cubes?

In the example above, games 1, 2, and 5 would have been possible if the bag had been loaded with that
configuration. However, game 3 would have been impossible because at one point the Elf showed you 20 red cubes at
once; similarly, game 4 would also have been impossible because the Elf showed you 15 blue cubes at once. If you
add up the IDs of the games that would have been possible, you get 8.

Determine which games would have been possible if the bag had been loaded with only 12 red cubes, 13 green cubes,
and 14 blue cubes. What is the sum of the IDs of those games?

=end

class CubeGame
  def self.sum_of_possible_game_ids(input, bag)
    games = input.lines.map { new(_1) }
    possible_games = games.filter { _1.possible?(bag) }
    possible_games.sum &:id
  end

  attr :id, :reveals

  def initialize(game_record)
    id_label, reveal_records = game_record.split(': ')
    @id = id_label.split(' ')[1].to_i
    @reveals = reveal_records.split('; ').map { Reveal.new(_1) }
  end

  def possible?(bag)
    reveals.all? { _1.possible?(bag) }
  end

  class Reveal
    def initialize(record)
      color_amounts = record.split(', ')
      @revealed = color_amounts.map do
        amount, color = _1.split(' ')
        [color.to_sym, amount.to_i]
      end
    end

    def possible?(bag)
      @revealed.all? do |color, amount|
        amount <= bag[color]
      end
    end
  end
end

if defined? DATA
  input = DATA.read
  puts CubeGame.sum_of_possible_game_ids(input, red: 12, green: 13, blue: 14)
end

__END__
Game 1: 2 red, 2 green; 1 red, 1 green, 2 blue; 3 blue, 3 red, 3 green; 1 blue, 3 green, 7 red; 5 red, 3 green, 1 blue
Game 2: 5 green, 4 red, 7 blue; 7 red, 4 green, 4 blue; 8 green, 11 blue, 4 red; 2 red, 18 blue, 3 green; 7 red, 15 blue
Game 3: 2 green, 4 blue; 2 red, 2 green; 6 red, 1 green; 2 red, 1 green; 2 green; 5 blue, 5 red
Game 4: 10 red, 7 green, 10 blue; 8 red, 2 green; 9 green, 6 red, 5 blue; 8 green, 2 blue, 4 red; 5 green, 9 blue; 10 red, 1 green, 9 blue
Game 5: 10 blue, 7 green, 2 red; 2 blue, 4 red; 2 green, 9 blue, 8 red
Game 6: 3 green, 8 red; 1 blue, 11 red, 2 green; 2 green, 15 red, 8 blue; 13 red, 6 blue, 3 green
Game 7: 4 green, 10 red, 7 blue; 6 red, 9 blue, 9 green; 2 red, 1 blue, 6 green
Game 8: 1 red, 3 blue, 2 green; 7 green, 2 blue; 10 green, 1 red, 2 blue; 1 red
Game 9: 4 red, 3 green, 11 blue; 6 red, 4 green; 15 red, 7 blue, 7 green
Game 10: 7 red, 1 blue, 5 green; 11 red, 7 green, 1 blue; 2 green, 4 blue, 13 red
Game 11: 2 blue, 13 red, 12 green; 6 green, 5 red, 4 blue; 5 red, 11 green
Game 12: 7 blue, 3 red, 11 green; 5 red, 1 blue, 8 green; 9 green, 7 blue, 8 red
Game 13: 1 blue, 12 red; 9 red, 1 green, 1 blue; 8 red; 1 green, 4 red; 2 red
Game 14: 6 blue, 5 green, 1 red; 12 blue, 4 red, 9 green; 7 green, 6 red; 8 blue, 10 green, 4 red; 8 green, 7 red
Game 15: 15 blue, 10 red, 3 green; 9 green, 6 red, 11 blue; 3 green, 8 red, 5 blue; 12 green, 6 red, 16 blue; 11 red, 9 green, 15 blue
Game 16: 12 green, 2 red, 7 blue; 9 red, 6 blue, 9 green; 7 green, 10 blue; 9 blue, 3 red, 9 green; 5 blue, 1 red
Game 17: 4 green, 3 red, 11 blue; 8 green, 16 blue; 10 green, 12 blue, 2 red; 8 green, 2 red, 15 blue
Game 18: 6 red, 8 green; 16 blue; 4 blue, 6 red; 16 blue, 10 green, 3 red; 12 blue, 15 green; 9 blue, 1 green, 4 red
Game 19: 9 green, 9 red; 4 green, 13 red, 2 blue; 2 blue, 4 green, 3 red; 5 green, 3 blue, 3 red
Game 20: 1 green, 6 red, 12 blue; 3 green, 8 red, 11 blue; 7 green, 5 red, 2 blue; 5 green, 14 blue, 5 red
Game 21: 5 green, 1 blue, 13 red; 3 green, 13 red, 2 blue; 8 green, 12 red, 3 blue; 3 blue, 6 green, 9 red; 1 blue, 4 green, 13 red
Game 22: 8 green, 14 red, 15 blue; 10 blue, 8 red, 14 green; 15 green, 15 blue, 6 red; 14 green, 10 blue, 7 red
Game 23: 18 red, 9 green; 3 green, 1 blue, 17 red; 10 red, 16 green
Game 24: 1 red, 2 blue, 4 green; 2 red, 5 blue, 3 green; 5 green, 5 blue; 8 blue, 1 red, 3 green; 2 green, 2 red, 6 blue; 2 green, 4 blue
Game 25: 5 blue, 4 red, 1 green; 4 blue, 8 red, 1 green; 6 red, 5 blue; 8 red; 9 red, 3 blue; 1 green, 3 blue, 5 red
Game 26: 20 blue, 4 red, 15 green; 10 red, 2 green, 12 blue; 7 blue, 15 green, 9 red; 1 red, 10 green, 5 blue; 14 green, 7 red, 15 blue
Game 27: 17 red, 6 green; 6 green, 5 red, 3 blue; 4 green, 4 red, 5 blue; 3 green, 3 blue, 16 red; 4 blue, 5 green, 15 red
Game 28: 5 blue, 6 green, 1 red; 13 blue; 1 red, 9 blue, 10 green
Game 29: 1 red, 10 blue; 9 green, 6 blue, 3 red; 17 green, 1 red, 9 blue; 7 blue, 1 red; 1 red, 15 blue, 9 green; 7 green, 1 red, 4 blue
Game 30: 3 red, 11 blue, 2 green; 11 green, 8 blue, 8 red; 1 red, 3 green; 19 green, 11 blue
Game 31: 19 green, 6 red; 4 green, 10 red; 12 green, 1 blue
Game 32: 4 green, 3 blue, 10 red; 4 red, 6 blue, 3 green; 10 red, 5 blue
Game 33: 2 blue, 5 green, 5 red; 4 blue, 2 green, 4 red; 13 red, 2 green; 7 blue, 4 green, 2 red; 19 blue, 5 green, 11 red; 4 green, 18 blue, 1 red
Game 34: 6 blue, 9 red, 7 green; 7 green, 6 red, 12 blue; 3 red, 6 green, 16 blue; 3 green, 15 blue, 13 red; 2 green, 16 blue, 3 red
Game 35: 4 green; 3 green, 4 red, 1 blue; 6 red, 12 green, 2 blue
Game 36: 1 blue, 8 red, 3 green; 10 red, 5 green; 1 green, 8 red; 4 green, 1 blue, 11 red
Game 37: 2 red, 4 blue, 5 green; 2 green, 1 blue, 3 red; 8 green, 3 red, 4 blue; 1 blue, 8 green, 2 red
Game 38: 11 green, 4 blue; 2 blue, 11 green, 1 red; 12 green, 7 blue, 1 red; 7 blue, 10 green, 1 red; 13 green, 2 red; 1 red, 7 blue, 2 green
Game 39: 7 green, 1 red, 15 blue; 8 red, 7 blue; 15 red, 5 green, 6 blue
Game 40: 2 green, 12 blue, 15 red; 2 green, 6 red; 5 green, 9 red; 9 blue, 12 red; 4 green, 12 red, 12 blue; 12 red, 8 blue, 2 green
Game 41: 9 blue, 6 red, 3 green; 6 red, 2 green, 9 blue; 1 blue, 11 red
Game 42: 4 red, 3 blue, 13 green; 5 blue, 11 red, 15 green; 3 red, 12 green; 2 red, 6 blue, 3 green
Game 43: 2 green, 7 red; 11 red, 18 green, 1 blue; 13 red, 12 green, 1 blue; 15 red; 5 red, 19 green; 15 green, 5 red
Game 44: 2 red, 5 green, 7 blue; 5 green, 8 blue; 8 red, 8 green; 1 green, 1 red, 6 blue; 1 blue, 1 red
Game 45: 3 red, 3 green, 7 blue; 12 red, 17 blue; 7 green, 8 red, 14 blue; 9 green, 10 red, 13 blue; 15 green, 16 blue, 4 red
Game 46: 2 blue, 5 green; 4 red, 7 green; 15 red, 7 green
Game 47: 5 red, 9 green, 4 blue; 1 red, 9 green, 11 blue; 8 green, 1 red; 4 red, 4 blue, 3 green; 10 blue, 14 green
Game 48: 1 red, 14 blue, 11 green; 3 blue, 8 green; 5 green, 5 blue; 5 blue, 1 red, 8 green; 10 green, 2 red, 6 blue
Game 49: 11 blue, 5 red, 3 green; 7 blue, 12 red, 4 green; 9 green, 6 red; 4 green, 3 blue, 10 red
Game 50: 3 red, 8 blue, 13 green; 13 blue, 13 green; 3 green, 10 blue, 1 red; 12 green, 15 blue; 12 blue, 3 red, 8 green; 5 blue, 5 red, 4 green
Game 51: 3 green, 1 blue; 1 red; 1 green, 7 blue
Game 52: 3 red, 4 blue; 4 blue, 1 green, 2 red; 1 green, 3 red; 5 red, 1 green; 1 blue, 1 red, 1 green
Game 53: 5 red, 17 green, 4 blue; 15 red, 14 blue, 1 green; 9 blue, 5 green; 3 blue, 5 red, 9 green; 1 green, 15 blue, 10 red; 16 green, 10 blue
Game 54: 4 blue, 7 red, 1 green; 7 green, 8 red, 6 blue; 14 green, 1 blue, 5 red
Game 55: 4 blue, 4 green, 1 red; 1 green; 3 red
Game 56: 3 green, 1 red, 7 blue; 1 blue, 2 red, 3 green; 2 green, 9 red; 14 red, 8 blue, 1 green; 5 red, 13 blue; 6 red, 3 blue
Game 57: 15 green, 5 red, 5 blue; 13 green, 13 blue, 12 red; 18 green, 5 blue, 8 red; 7 green, 7 blue, 13 red
Game 58: 4 red, 2 blue, 6 green; 4 red, 3 green, 14 blue; 9 green, 3 red; 3 red, 5 blue, 11 green
Game 59: 2 red, 6 green, 1 blue; 5 blue, 1 green, 4 red; 2 red, 7 green, 6 blue; 3 green, 6 blue; 1 blue, 6 green
Game 60: 4 red, 9 green, 3 blue; 2 blue, 8 green, 6 red; 2 red, 8 green, 3 blue; 8 green, 2 red, 2 blue
Game 61: 12 red, 4 blue, 3 green; 1 blue, 2 green; 2 red, 2 green, 3 blue
Game 62: 4 red, 6 green, 14 blue; 12 green, 2 red, 4 blue; 5 blue, 5 red, 7 green
Game 63: 1 green, 5 red; 5 red, 1 blue, 1 green; 1 blue
Game 64: 6 red, 9 green, 4 blue; 8 red, 13 green; 3 blue, 8 red, 11 green; 5 red, 1 blue, 2 green; 3 blue, 7 red, 1 green
Game 65: 15 green, 10 red, 1 blue; 1 blue, 2 red, 4 green; 10 blue, 4 green
Game 66: 13 blue, 6 red, 2 green; 13 green; 10 blue, 8 green; 7 red, 10 blue, 11 green; 10 green, 1 red, 8 blue
Game 67: 5 blue, 4 green, 1 red; 2 green, 4 blue, 1 red; 7 green, 2 blue, 1 red; 1 blue, 1 green
Game 68: 2 green, 12 blue, 3 red; 5 red, 14 blue, 2 green; 6 red, 14 blue; 10 blue, 6 red, 2 green
Game 69: 7 blue, 1 red, 12 green; 10 blue, 11 green, 6 red; 4 red, 10 green, 7 blue
Game 70: 4 blue; 6 red, 2 green, 11 blue; 4 green, 3 blue, 2 red; 14 blue, 2 red, 4 green
Game 71: 5 red, 17 blue; 9 blue, 11 red, 1 green; 19 blue, 6 red; 4 red, 2 blue
Game 72: 2 green, 5 red, 1 blue; 4 green, 4 red; 4 green, 2 red; 2 blue, 2 green; 1 blue, 1 green, 5 red
Game 73: 4 red, 3 blue, 1 green; 10 red, 2 blue, 3 green; 14 red, 1 green, 2 blue; 1 blue; 3 green, 9 red, 6 blue; 11 red, 7 blue, 2 green
Game 74: 1 red, 5 blue, 10 green; 2 red, 9 blue, 9 green; 8 green, 2 red, 4 blue; 10 blue, 9 green; 12 green, 3 red, 5 blue
Game 75: 3 red, 13 blue, 6 green; 3 green, 1 red; 9 green, 1 blue, 5 red; 5 green, 13 red, 4 blue; 13 green, 2 blue, 10 red; 9 green, 3 red, 10 blue
Game 76: 14 green, 2 red, 16 blue; 2 blue, 1 red, 7 green; 14 green, 9 blue, 8 red
Game 77: 1 green, 1 blue; 1 green; 3 red, 3 blue, 1 green; 3 green, 3 red; 1 red, 2 blue
Game 78: 4 red, 13 green; 17 green, 1 blue, 2 red; 8 red, 14 green
Game 79: 4 green, 10 red, 6 blue; 5 blue, 3 red, 7 green; 6 blue, 2 red, 4 green; 2 blue, 8 red
Game 80: 19 green, 5 red; 5 green, 9 blue; 3 red, 18 blue, 10 green; 2 red, 15 green, 7 blue; 4 red, 14 green, 15 blue
Game 81: 10 red, 2 blue, 1 green; 18 red, 3 blue; 6 red, 12 blue; 1 green, 3 red, 3 blue
Game 82: 8 green, 1 blue; 2 blue, 4 red; 7 green, 1 red, 4 blue; 2 green, 3 red, 2 blue; 3 red; 4 red, 8 green, 1 blue
Game 83: 3 green, 1 blue; 1 red, 2 blue, 14 green; 8 red, 17 green
Game 84: 7 green, 4 blue, 4 red; 11 green, 17 red, 11 blue; 9 green, 5 blue, 14 red; 9 green, 10 blue, 5 red
Game 85: 1 red, 1 green; 1 blue, 8 red, 1 green; 8 green, 1 red; 8 green, 2 red, 1 blue
Game 86: 1 red, 5 blue, 1 green; 1 green, 7 red; 8 red; 3 blue, 2 red
Game 87: 7 red, 8 blue, 1 green; 8 red, 6 green; 6 red, 8 green, 10 blue
Game 88: 5 red, 4 green, 5 blue; 1 blue, 2 green; 6 green, 10 blue, 4 red; 1 red, 8 green, 1 blue
Game 89: 3 green, 7 blue, 11 red; 1 blue, 5 green, 18 red; 1 blue, 3 green, 13 red; 7 blue, 9 green, 3 red; 1 green, 8 blue, 19 red; 4 blue, 15 red, 1 green
Game 90: 3 blue, 3 red, 4 green; 14 red, 6 green, 4 blue; 1 blue, 9 red; 6 red, 1 green; 5 green, 8 red, 2 blue; 3 blue, 4 red, 3 green
Game 91: 1 red, 1 blue, 16 green; 8 red, 5 green; 1 blue, 2 red, 10 green; 3 red, 15 green, 1 blue
Game 92: 10 green, 12 blue; 6 red, 6 blue; 5 red, 12 blue; 6 red, 9 green, 2 blue; 10 blue, 3 red, 1 green; 1 red, 19 blue, 11 green
Game 93: 4 green; 5 green, 2 blue, 3 red; 1 blue, 3 red, 6 green; 2 blue, 2 red, 7 green
Game 94: 4 blue, 2 red; 6 green, 6 blue, 4 red; 8 green, 1 blue, 3 red
Game 95: 6 green, 4 blue, 15 red; 13 red, 7 blue, 3 green; 14 red, 5 blue, 6 green; 5 blue, 7 red, 2 green
Game 96: 1 red, 1 blue, 11 green; 6 blue, 2 red, 14 green; 3 green, 2 red; 9 blue, 10 green
Game 97: 10 green; 2 red, 4 green, 1 blue; 2 green, 1 red; 2 red, 1 blue, 10 green; 1 green
Game 98: 1 green, 5 blue; 2 green, 7 blue, 4 red; 2 red, 1 green, 9 blue; 4 blue, 4 red
Game 99: 3 green, 1 red, 3 blue; 12 green, 12 blue, 4 red; 12 blue, 2 red, 10 green; 4 blue, 2 red, 4 green
Game 100: 1 red, 5 blue, 2 green; 3 red, 1 blue; 1 green, 1 blue, 1 red
