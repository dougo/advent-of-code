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
    refute state.player_wins?(%i())
    refute state.player_wins?(%i(poison magic_missile))
  end

  def test_example1
    spells = %i(poison magic_missile)
    assert_equal 173+53, Player.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 13, damage: 8))
    assert state.player_wins?(spells)
    # TODO: test verbose output
  end

  def test_example2
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    refute state.player_wins?(%i(poison magic_missile))

    spells = %i(recharge shield drain poison magic_missile)
    assert_equal 229+113+73+173+53, Player.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    assert state.player_wins?(spells)
    # TODO: test verbose output
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
end
