require 'test-helper'
require 'day-22-wizard-simulator-20xx'

class TestDay22WizardSimulator20xx < Minitest::Test
  def setup
    @subject = CombatState.new(Player.new, Boss.new(hp: 100))
  end

  def test_boss_parse
    boss = Boss.parse("Hit Points: 13\nDamage: 8")
    assert_equal 13, boss.hp
    assert_equal 8, boss.damage
  end

  # Magic Missile costs 53 mana. It instantly does 4 damage.
  def test_magic_missile
    state = @subject.next(:magic_missile)
    assert_equal 447, state.player.mana
    assert_equal 96, state.boss.hp
  end

  # Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
  def test_drain
    state = @subject.next(:drain)
    assert_equal 427, state.player.mana
    assert_equal 51, state.player.hp # Turn 1: player heals 2 hp, Turn 2: player takes 1 damage from the boss
    assert_equal 98, state.boss.hp
  end

  # Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased
  # by 7.
  def test_shield
    # Turns 1 and 2:
    state = @subject.next(:shield)
    assert_equal 387, state.player.mana
    assert_equal 7, state.player.armor

    # Turns 3 and 4:
    state = state.next(:magic_missile)
    assert_equal 7, state.player.armor
    
    # Turns 5 and 6:
    state = state.next(:magic_missile)
    assert_equal 7, state.player.armor

    # Turns 7 and 8, shield has expired:
    state = state.next(:magic_missile)
    assert_equal 0, state.player.armor
  end

  # Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active,
  # it deals the boss 3 damage.
  def test_poison
    # Turns 1 and 2, poison starts on turn 2:
    state = @subject.next(:poison)
    assert_equal 327, state.player.mana
    assert_equal 97, state.boss.hp

    # Turns 3 and 4:
    state = state.next(:magic_missile)
    # 4 damage for magic missile, 6 for two turns of poison
    assert_equal 87, state.boss.hp
    
    # Turns 5 and 6:
    state = state.next(:magic_missile)
    assert_equal 77, state.boss.hp

    # Turns 7 and 8, poison ends on turn 7:
    state = state.next(:magic_missile)
    assert_equal 70, state.boss.hp
  end

  # Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is
  # active, it gives you 101 new mana.
  def test_recharge
    # Turns 1 and 2, recharge starts on turn 2:
    state = @subject.next(:recharge)
    assert_equal 372, state.player.mana # 500 - 229 + 101

    # Turns 3 and 4:
    state = state.next(:magic_missile)
    assert_equal 521, state.player.mana # 372 - 53 + 101 + 101
    
    # Turns 5 and 6, reharge ends on turn 6:
    state = state.next(:magic_missile)
    assert_equal 670, state.player.mana # 521 - 53 + 101 + 101

    # Turns 7 and 8:
    state = state.next(:magic_missile)
    assert_equal 617, state.player.mana # 670 - 53
  end

  def test_lose
    state = CombatState.new(Player.new(mana: 10), Boss.new(hp: 13, damage: 8))
    assert_raises(PlayerLost) { state.simulate!(%i(poison magic_missile)) }
  end

  def test_example1
    spells = %i(poison magic_missile)
    assert_equal 173+53, Player.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 13, damage: 8))
    assert_raises(BossDead) { state.simulate!(spells) }
    assert_equal 0, state.boss.hp
    assert_equal expected_output_example1, state.output
  end

  def test_example2
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    assert_raises(PlayerDead) { state.simulate!(%i(poison magic_missile)) }

    spells = %i(recharge shield drain poison magic_missile)
    assert_equal 229+113+73+173+53, Player.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    assert_raises(BossDead) { state.simulate!(spells) }
    assert_equal expected_output_example2, state.output
  end

  def test_cheapest_winning_spell_sequence
    sim = WizardSimulator.new(Boss.new(hp: 1, damage: 0))
    assert_nil sim.cheapest_winning_spell_sequence(max_cost: 52)
    assert_equal %i(magic_missile), sim.cheapest_winning_spell_sequence

    sim = WizardSimulator.new(Boss.new(hp: 5, damage: 0))
    assert_equal %i(magic_missile magic_missile), sim.cheapest_winning_spell_sequence

    sim = WizardSimulator.new(Boss.new(hp: 5, damage: 50))
    assert_equal %i(drain magic_missile), sim.cheapest_winning_spell_sequence
  end

  # TODO: hard_mode

  private

  def expected_output_example1
    # NOTE: for the boss attack, changed the period to an exclamation point to be consistent with example 2...
    return <<END
-- Player turn --
- Player has 10 hit points, 0 armor, 250 mana
- Boss has 13 hit points
Player casts Poison.

-- Boss turn --
- Player has 10 hit points, 0 armor, 77 mana
- Boss has 13 hit points
Poison deals 3 damage; its timer is now 5.
Boss attacks for 8 damage!

-- Player turn --
- Player has 2 hit points, 0 armor, 77 mana
- Boss has 10 hit points
Poison deals 3 damage; its timer is now 4.
Player casts Magic Missile, dealing 4 damage.

-- Boss turn --
- Player has 2 hit points, 0 armor, 24 mana
- Boss has 3 hit points
Poison deals 3 damage. This kills the boss, and the player wins.
END
  end

  def expected_output_example2
    return <<END
-- Player turn --
- Player has 10 hit points, 0 armor, 250 mana
- Boss has 14 hit points
Player casts Recharge.

-- Boss turn --
- Player has 10 hit points, 0 armor, 21 mana
- Boss has 14 hit points
Recharge provides 101 mana; its timer is now 4.
Boss attacks for 8 damage!

-- Player turn --
- Player has 2 hit points, 0 armor, 122 mana
- Boss has 14 hit points
Recharge provides 101 mana; its timer is now 3.
Player casts Shield, increasing armor by 7.

-- Boss turn --
- Player has 2 hit points, 7 armor, 110 mana
- Boss has 14 hit points
Shield's timer is now 5.
Recharge provides 101 mana; its timer is now 2.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 1 hit point, 7 armor, 211 mana
- Boss has 14 hit points
Shield's timer is now 4.
Recharge provides 101 mana; its timer is now 1.
Player casts Drain, dealing 2 damage, and healing 2 hit points.

-- Boss turn --
- Player has 3 hit points, 7 armor, 239 mana
- Boss has 12 hit points
Shield's timer is now 3.
Recharge provides 101 mana; its timer is now 0.
Recharge wears off.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 2 hit points, 7 armor, 340 mana
- Boss has 12 hit points
Shield's timer is now 2.
Player casts Poison.

-- Boss turn --
- Player has 2 hit points, 7 armor, 167 mana
- Boss has 12 hit points
Shield's timer is now 1.
Poison deals 3 damage; its timer is now 5.
Boss attacks for 8 - 7 = 1 damage!

-- Player turn --
- Player has 1 hit point, 7 armor, 167 mana
- Boss has 9 hit points
Shield's timer is now 0.
Shield wears off, decreasing armor by 7.
Poison deals 3 damage; its timer is now 4.
Player casts Magic Missile, dealing 4 damage.

-- Boss turn --
- Player has 1 hit point, 0 armor, 114 mana
- Boss has 2 hit points
Poison deals 3 damage. This kills the boss, and the player wins.
END
  end
end
