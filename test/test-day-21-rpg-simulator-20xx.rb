require 'test-helper'
require 'day-21-rpg-simulator-20xx'

class TestDay21RPGSimulator20XX < Minitest::Test
  def setup
    @player = Character.new(hp: 8, damage: 5, armor: 5)
    @boss = Character.new(hp: 12, damage: 7, armor: 2)
    @boss2 = Character.new(hp: 13, damage: 7, armor: 2)
  end

  def test_damage_dealt_to
    # If the attacker has a damage score of 8, and the defender has an armor score of 3, the defender loses 5 hit
    # points.
    assert_equal 5, Character.new(damage: 8).damage_dealt_to(Character.new(armor: 3))

    # If the defender had an armor score of 300, the defender would still lose 1 hit point.
    assert_equal 1, Character.new(damage: 8).damage_dealt_to(Character.new(armor: 300))

    # The player deals 5-2 = 3 damage.
    assert_equal 3, @player.damage_dealt_to(@boss)

    # The boss deals 7-5 = 2 damage.
    assert_equal 2, @boss.damage_dealt_to(@player)
  end

  def test_rounds_to_kill
    # At 3 damage per round, it takes the player 4 rounds to do 12 damage.
    assert_equal 4, @player.rounds_to_kill(@boss)

    # At 2 damage per round, it takes the boss 4 rounds to do 8 damage.
    assert_equal 4, @boss.rounds_to_kill(@player)

    # If the boss has one more hp, the player needs another whole round to kill it.
    assert_equal 5, @player.rounds_to_kill(@boss2)
  end

  def test_defeats?
    # Both can kill the other in 4 rounds, so the attacker wins!
    assert @player.defeats?(@boss)
    assert @boss.defeats?(@player)

    # If the boss has one more hp, it survives round 4 to kill the player.
    refute @player.defeats?(@boss2)
  end

  def test_equipment
    dagger     = Equipment.new(8,  4, 0)
    splintmail = Equipment.new(53, 0, 3)

    c1 = Character.new(equipment: [dagger, splintmail])
    assert_equal [dagger, splintmail], c1.equipment
    assert_equal 61, c1.cost
    assert_equal 4, c1.damage
    assert_equal 3, c1.armor

    damage_plus_one  = Equipment.new(25, 1, 0)
    defense_plus_two = Equipment.new(40, 0, 2)

    c2 = Character.new(equipment: [dagger, splintmail, damage_plus_one, defense_plus_two])
    assert_equal [dagger, splintmail, damage_plus_one, defense_plus_two], c2.equipment
    assert_equal 126, c2.cost
    assert_equal 5, c2.damage
    assert_equal 5, c2.armor
  end

  def test_store
    weapons, armor, rings = Equipment::WEAPONS, Equipment::ARMOR, Equipment::RINGS
    assert_equal 5, weapons.length
    assert_equal 5, armor.length
    assert_equal 6, rings.length

    assert_equal 6, weapons[2].damage # I had a typo in the table here :(
  end

  # TODO: test_all_equipment_combos

  def test_all_players
    chars = Character.all_players
    costs = chars.map &:cost
    assert_equal costs.sort, costs, 'should be sorted from cheapest to most expensive'
    # TODO: test legality of equipment combos?

    cheapest = chars.first
    assert_equal 8, cheapest.cost
    assert_equal 4, cheapest.damage
    assert_equal 0, cheapest.armor

    most_expensive = chars.last # Greataxe + Platemail + Damage +3 + Defense +3
    assert_equal 356, most_expensive.cost
    assert_equal 11, most_expensive.damage
    assert_equal 8, most_expensive.armor
  end

  def test_cheapest_player_that_defeats
    easy = Character.new
    p1 = Character.cheapest_player_that_defeats(easy)
    assert_equal 8, p1.cost

    hard = Character.new(hp: 101, damage: 11, armor: 8)
    p2 = Character.cheapest_player_that_defeats(hard)
    assert_equal 356, p2.cost
  end

  def test_most_expensive_player_defeated_by
  end
end

=begin

Can this be solved with math??

102 hp, 9 damage, 2 armor

rounds to kill boss   = 102 / (player.damage - 2)
damage sustained = ((102 / (D-2)) - 1) * (9 - A)
defeat: ((102 / (D-2)) - 1) * (9 - A) < 100
(102 / (D-2)) - 1 < 100 / (9-A)
(102 / (D-2)) - (D-2)/(D-2) < 100 / (9-A)
(102 - D-2) / (D-2) < 100 / (9-A)
(9-A)(100-D) < 100(D-2)
900 - 100A - 9D + AD < 100D - 2
902 - 100A + 91D + AD < 0
902 < 100A - 91D - AD

=end
