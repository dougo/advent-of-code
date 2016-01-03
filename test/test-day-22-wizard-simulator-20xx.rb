require 'test-helper'
require 'day-22-wizard-simulator-20xx'

class TestDay22WizardSimulator20xx < Minitest::Test
  def test_example1
    spells = %i(poison magic_missile)
    assert_equal 173+53, WizardSimulator.new.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 13, damage: 8))
    assert state.player_wins?(spells)
  end

  def test_example2
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    refute state.player_wins?(%i(poison magic_missile))

    spells = %i(recharge shield drain poison magic_missile)
    assert_equal 229+113+73+173+53, WizardSimulator.new.spell_sequence_cost(spells)
    state = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    assert state.player_wins?(spells)
  end

  def test_cheapest_winning_spell_sequence
    # TODO
  end
end
