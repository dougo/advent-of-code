require 'test-helper'
require 'day-22-wizard-simulator-20xx'

class TestDay22WizardSimulator20xx < Minitest::Test
  # TODO: Boss.parse

  def test_shield
    state = CombatState.new(Player.new(mana: 500), Boss.new(hp: 100))

    # Turns 1 and 2:
    state = state.next(:shield)
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
    # TODO
  end

  # TODO: hard_mode
end
