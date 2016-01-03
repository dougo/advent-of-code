require 'test-helper'
require 'day-22-wizard-simulator-20xx'

class TestDay22WizardSimulator20xx < Minitest::Test
  def test_example1
    @subject = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 13, damage: 8))
    assert @subject.player_wins?(%i(poison magic_missile))
  end

  def test_example2
    @subject = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    refute @subject.player_wins?(%i(poison magic_missile))

    @subject = CombatState.new(Player.new(hp: 10, mana: 250), Boss.new(hp: 14, damage: 8))
    assert @subject.player_wins?(%i(recharge shield drain poison magic_missile))
  end

  def test_cheapest_winning_spell_sequence
    # TODO
  end
end
