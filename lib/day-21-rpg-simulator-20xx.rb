=begin

Little Henry Case got a new video game for Christmas. It's an RPG, and he's stuck on a boss. He needs to know what
equipment to buy at the shop. He hands you the controller.

In this game, the player (you) and the enemy (the boss) take turns attacking. The player always goes first. Each
attack reduces the opponent's hit points by at least 1. The first character at or below 0 hit points loses.

Damage dealt by an attacker each turn is equal to the attacker's damage score minus the defender's armor score. An
attacker always does at least 1 damage. So, if the attacker has a damage score of 8, and the defender has an armor
score of 3, the defender loses 5 hit points. If the defender had an armor score of 300, the defender would still
lose 1 hit point.

Your damage score and armor score both start at zero. They can be increased by buying items in exchange for
gold. You start with no items and have as much gold as you need. Your total damage or armor is equal to the sum of
those stats from all of your items. You have 100 hit points.

Here is what the item shop is selling:

Weapons:    Cost  Damage  Armor
Dagger        8     4       0
Shortsword   10     5       0
Warhammer    25     6       0
Longsword    40     7       0
Greataxe     74     8       0

Armor:      Cost  Damage  Armor
Leather      13     0       1
Chainmail    31     0       2
Splintmail   53     0       3
Bandedmail   75     0       4
Platemail   102     0       5

Rings:      Cost  Damage  Armor
Damage +1    25     1       0
Damage +2    50     2       0
Damage +3   100     3       0
Defense +1   20     0       1
Defense +2   40     0       2
Defense +3   80     0       3

You must buy exactly one weapon; no dual-wielding. Armor is optional, but you can't use more than one. You can buy
0-2 rings (at most one for each hand). You must use any items you buy. The shop only has one of each item, so you
can't buy, for example, two rings of Damage +3.

For example, suppose you have 8 hit points, 5 damage, and 5 armor, and that the boss has 12 hit points, 7 damage,
and 2 armor:

 - The player deals 5-2 = 3 damage; the boss goes down to 9 hit points.
 - The boss deals 7-5 = 2 damage; the player goes down to 6 hit points.
 - The player deals 5-2 = 3 damage; the boss goes down to 6 hit points.
 - The boss deals 7-5 = 2 damage; the player goes down to 4 hit points.
 - The player deals 5-2 = 3 damage; the boss goes down to 3 hit points.
 - The boss deals 7-5 = 2 damage; the player goes down to 2 hit points.
 - The player deals 5-2 = 3 damage; the boss goes down to 0 hit points.

In this scenario, the player wins! (Barely.)

You have 100 hit points. The boss's actual stats are in your puzzle input. What is the least amount of gold you can
spend and still win the fight?

=end

require 'mathn' # Use rationals for integer division!
require_relative 'util'

class Equipment
  def initialize(cost, damage, armor)
    @cost, @damage, @armor = cost, damage, armor
  end

  attr_reader :cost, :damage, :armor

  def to_s
    [cost, damage, armor].to_s
  end

  def inspect
    to_s
  end

  WEAPONS = [new(8, 4, 0),
             new(10, 5, 0),
             new(25, 6, 0),
             new(40, 7, 0),
             new(74, 8, 0)]

  ARMOR = [new(13, 0, 1),
           new(31, 0, 2),
           new(53, 0, 3),
           new(75, 0, 4),
           new(102, 0, 5)]

  RINGS = [new(25, 1, 0),
           new(50, 2, 0),
           new(100, 3, 0),
           new(20, 0, 1),
           new(40, 0, 2),
           new(80, 0, 3)]
end

class Character
  def initialize(hp: 0, damage: 0, armor: 0, equipment: [])
    @hp, @damage, @armor, @equipment = hp, damage, armor, equipment
  end

  attr_reader :hp, :equipment

  def damage
    @equipment.sum(&:damage) + @damage
  end

  def armor
    @equipment.sum(&:armor)  + @armor
  end

  def cost
    @equipment.sum(&:cost)
  end

  def to_s
    [cost, @hp, @damage, @armor, @equipment].to_s
  end

  def inspect
    to_s
  end

  def damage_dealt_to(defender)
    [damage - defender.armor, 1].max
  end

  def rounds_to_kill(defender)
    (defender.hp / damage_dealt_to(defender)).ceil
  end

  def defeats?(defender)
    damage_sustained = (rounds_to_kill(defender) - 1) * defender.damage_dealt_to(self)
    damage_sustained < hp
  end

  def self.all_equipment_combos
    combos = Equipment::WEAPONS.product([nil] + Equipment::ARMOR,
                                        [nil] + Equipment::RINGS + Equipment::RINGS.combination(2).to_a)
    combos.map(&:flatten).map(&:compact)
  end

  def self.all_players
    all_equipment_combos.map { |e| new(hp: 100, equipment: e) }.sort_by(&:cost)
  end

  def self.cheapest_player_that_defeats(defender)
    all_players.find { |p| p.defeats?(defender) }
  end

  def self.most_expensive_player_defeated_by(defender)
    all_players.reverse.find { |p| !p.defeats?(defender) }
  end
end

if defined? DATA
  boss = Character.new(hp: 103, damage: 9, armor: 2)
  p Character.cheapest_player_that_defeats(boss).cost
  p Character.most_expensive_player_defeated_by(boss).cost
end

__END__
Hit Points: 103
Damage: 9
Armor: 2
