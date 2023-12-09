require 'test-helper'
require '2015/day-21-rpg-simulator-20xx'

class TestDay21RPGSimulator20XX < Minitest::Test
  def setup
    @player = Character.new(hp: 8, damage: 5, armor: 5)
    @boss = Character.new(hp: 12, damage: 7, armor: 2)
    @boss2 = Character.new(hp: 13, damage: 7, armor: 2)
  end

  def test_parse
    input = <<END
Hit Points: 12
Damage: 7
Armor: 2
END
    char = Character.parse(input)
    assert_equal 12, char.hp
    assert_equal 7, char.damage
    assert_equal 2, char.armor
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

  def test_all_players
    chars = Character.all_players

    # 5 weapons, 5 types of armor (plus the no-armor option), zero to two out of 6 rings
    assert_equal 5*(5+1)*(1+6+(6*5)/2), chars.size

    costs = chars.map &:cost
    assert_equal costs.sort, costs, 'should be sorted from cheapest to most expensive'

    cheapest = chars.first # Dagger
    assert_equal 8, cheapest.cost
    assert_equal 4, cheapest.damage
    assert_equal 0, cheapest.armor

    most_expensive = chars.last # Greataxe + Platemail + Damage +3 + Defense +3
    assert_equal 356, most_expensive.cost
    assert_equal 11, most_expensive.damage
    assert_equal 8, most_expensive.armor

    chars.each do |char|
      assert_equal    1,       char.equipment.count { |x| x.in? Equipment::WEAPONS }
      assert_includes [0,1],   char.equipment.count { |x| x.in? Equipment::ARMOR }
      assert_includes [0,1,2], char.equipment.count { |x| x.in? Equipment::RINGS }
    end
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
    easy = Character.new(hp: 101, damage: 4)
    p1 = Character.most_expensive_player_defeated_by(easy)
    assert_equal 8, p1.cost

    hard = Character.new(hp: 101, damage: 12, armor: 8)
    p2 = Character.most_expensive_player_defeated_by(hard)
    assert_equal 356, p2.cost
  end
end

=begin

Can this be solved with math??

103 hp, 9 damage, 2 armor

rounds to kill boss   = 103 / (player.damage - 2)
damage sustained = ((103 / (D-2)) - 1) * (9 - A)
defeat: ((103 / (D-2)) - 1) * (9 - A) < 100
(103 / (D-2)) - 1 < 100 / (9-A)
(103 / (D-2)) - (D-2)/(D-2) < 100 / (9-A)
(103 - D-2) / (D-2) < 100 / (9-A)
(9-A)(101-D) < 100(D-2)
909 - 101A - 9D + AD < 100D - 200
1109 - 101A - 109D + AD < 0
109D + 101A - AD > 1109

=end
