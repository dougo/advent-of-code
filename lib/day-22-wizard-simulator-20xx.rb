=begin

--- Day 22: Wizard Simulator 20XX ---

Little Henry Case decides that defeating bosses with swords and stuff is boring. Now he's playing the game with a
wizard. Of course, he gets stuck on another boss and needs your help again.

In this version, combat still proceeds with the player and the boss taking alternating turns. The player still goes
first. Now, however, you don't get any equipment; instead, you must choose one of your spells to cast. The first
character at or below 0 hit points loses.

Since you're a wizard, you don't get to wear armor, and you can't attack normally. However, since you do magic
damage, your opponent's armor is ignored, and so the boss effectively has zero armor as well. As before, if armor
(from a spell, in this case) would reduce damage below 1, it becomes 1 instead - that is, the boss' attacks always
deal at least 1 damage.

On each of your turns, you must select one of your spells to cast. If you cannot afford to cast any spell, you
lose. Spells cost mana; you start with 500 mana, but have no maximum limit. You must have enough mana to cast a
spell, and its cost is immediately deducted when you cast it. Your spells are Magic Missile, Drain, Shield, Poison,
and Recharge.

 - Magic Missile costs 53 mana. It instantly does 4 damage.
 - Drain costs 73 mana. It instantly does 2 damage and heals you for 2 hit points.
 - Shield costs 113 mana. It starts an effect that lasts for 6 turns. While it is active, your armor is increased by 7.
 - Poison costs 173 mana. It starts an effect that lasts for 6 turns. At the start of each turn while it is active,
   it deals the boss 3 damage.
 - Recharge costs 229 mana. It starts an effect that lasts for 5 turns. At the start of each turn while it is
   active, it gives you 101 new mana.

Effects all work the same way. Effects apply at the start of both the player's turns and the boss' turns. Effects
are created with a timer (the number of turns they last); at the start of each turn, after they apply any effect
they have, their timer is decreased by one. If this decreases the timer to zero, the effect ends. You cannot cast a
spell that would start an effect which is already active. However, effects can be started on the same turn they
end.

For example, suppose the player has 10 hit points and 250 mana, and that the boss has 13 hit points and 8 damage:

-- Player turn --
- Player has 10 hit points, 0 armor, 250 mana
- Boss has 13 hit points
Player casts Poison.

-- Boss turn --
- Player has 10 hit points, 0 armor, 77 mana
- Boss has 13 hit points
Poison deals 3 damage; its timer is now 5.
Boss attacks for 8 damage.

-- Player turn --
- Player has 2 hit points, 0 armor, 77 mana
- Boss has 10 hit points
Poison deals 3 damage; its timer is now 4.
Player casts Magic Missile, dealing 4 damage.

-- Boss turn --
- Player has 2 hit points, 0 armor, 24 mana
- Boss has 3 hit points
Poison deals 3 damage. This kills the boss, and the player wins.

Now, suppose the same initial conditions, except that the boss has 14 hit points instead:

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

You start with 50 hit points and 500 mana points. The boss's actual stats are in your puzzle input. What is the
least amount of mana you can spend and still win the fight? (Do not include mana recharge effects as "spending"
negative mana.)

--- Part Two ---

On the next run through the game, you increase the difficulty to hard.

At the start of each player turn (before any other effects apply), you lose 1 hit point. If this brings you to or
below 0 hit points, you lose.

With the same starting stats for you and the boss, what is the least amount of mana you can spend and still win the
fight?

=end

require_relative 'util'

class BossDead < Exception; end
class PlayerDead < Exception; end
class PlayerLost < Exception; end
class CannotCast < Exception; end

class Combatant
  attr_reader :hp

  def take_damage!(damage)
    @hp -= damage
    die if @hp <= 0
  end
end

class Boss < Combatant
  def self.parse(input)
    input =~ /^Hit Points: (\d+)\nDamage: (\d+)$/
    new(hp: $1.to_i, damage: $2.to_i)
  end

  def initialize(hp: 0, damage: 0)
    @hp = hp
    @damage = damage
  end

  attr_reader :damage

  def to_s
    "Boss has #{@hp} hit points"
  end

  def die
    raise BossDead
  end
end

class Player < Combatant
  def initialize(hp: 50, mana: 500)
    @hp = hp
    @mana = mana
    @armor = 0
  end

  attr_accessor :armor, :mana, :state

  def to_s
    "Player has #{@hp} hit point#{@hp == 1 ? "" : "s"}, #{@armor} armor, #{@mana} mana"
  end

  def report(str)
    @state.report(str)
  end

  def die
    raise PlayerDead
  end

  SPELL_COSTS = {
    magic_missile: 53,
    drain: 73,
    shield: 113,
    poison: 173,
    recharge: 229
  }

  def self.spell_sequence_cost(spells)
    spells.sum { |spell| SPELL_COSTS[spell] }
  end

  def spell_class(spell)
    case spell
    when :shield
      Shield
    when :poison
      Poison
    when :recharge
      Recharge
    end
  end

  def spell_name(spell)
    spell == :magic_missile ? 'Magic Missile' : spell.capitalize
  end

  def cast_spell(spell)
    cl = spell_class(spell)
    name = spell_name(spell)
    if cl && @state.effects.find { |effect| effect.is_a? cl }
      raise CannotCast, "Can't cast #{name}, a #{cl} effect already exists."
    end

    if @mana >= SPELL_COSTS[spell]
      @mana -= SPELL_COSTS[spell]
      @state.report_hanging("Player casts #{name}")
      send(spell)
      report(".")
    else
      raise PlayerLost, "** Player does not have enough mana to cast #{spell}."
    end
  end

  def magic_missile
    @state.report_hanging(", dealing 4 damage")
    @state.boss.take_damage!(4)
  end

  def drain
    @state.report_hanging(", dealing 2 damage, and healing 2 hit points")
    @state.boss.take_damage!(2)
    @hp += 2
  end

  def shield
    @state.report_hanging(", increasing armor by 7")
    @armor += 7
    @state.add_effect!(Shield)
  end

  def poison
    @state.add_effect!(Poison)
  end

  def recharge
    @state.add_effect!(Recharge)
  end
end

class Effect
  def initialize
    @timer = duration
  end

  def name
    self.class.name
  end

  def magic(state)
  end

  def tick(state)
    magic(state)
    @timer -= 1
    report_timer(state)
    if @timer == 0
      state.report_hanging("#{name} wears off")
      expire(state)
      state.remove_effect!(self)
      state.report(".")
    end
  end

  def report_timer(state)
    state.report("; its timer is now #{@timer}.")
  end

  def expire(state)
  end
end

class Shield < Effect
  def duration
    6
  end

  def priority
    1
  end

  def report_timer(state)
    state.report("Shield's timer is now #{@timer}.")
  end

  def expire(state)
    state.player.armor -= 7
    state.report_hanging(", decreasing armor by 7")
  end
end

class Poison < Effect
  def duration
    6
  end

  def priority
    2
  end

  def magic(state)
    state.report_hanging("Poison deals 3 damage")
    state.boss.take_damage!(3)
  end
end

class Recharge < Effect
  def duration
    5
  end

  def priority
    3
  end

  def magic(state)
    state.report_hanging("Recharge provides 101 mana")
    state.player.mana += 101
  end
end

class CombatState
  def initialize(player, boss, hard_mode: false)
    @player, @boss, @hard_mode = player, boss, hard_mode
    @player.state = self
    @effects = []
    @output = ''
  end

  attr_accessor :player, :boss, :effects, :output

  def clone
    state = self.class.new(@player.clone, @boss.clone, hard_mode: @hard_mode)
    state.effects = effects.map &:clone
    state
  end

  def next(spell)
    clone.next!(spell)
  end

  def next!(spell)
    report('-- Player turn --')

    if @hard_mode
      report("HARD MODE: Player loses 1 hit point!")
      @player.take_damage!(1)
    end

    tick

    @player.cast_spell(spell)

    report("\n-- Boss turn --")
    tick

    damage = [1, @boss.damage - @player.armor].max
    if @player.armor > 0
      report("Boss attacks for #{@boss.damage} - #{@player.armor} = #{damage} damage!")
    else
      report("Boss attacks for #{@boss.damage} damage!")
    end
    @player.take_damage!(damage)
    report("")

    self
  end

  def simulate!(spells)
    spells.each &method(:next!)

    report("** No more spells to cast!")
  rescue BossDead
    report ". This kills the boss, and the player wins."
    raise
  end

  def report(str)
    report_hanging(str)
    report_hanging("\n")
  end

  def report_hanging(str)
    @output << str
  end

  def tick
    report("- #{@player}")
    report("- #{@boss}")
    @effects.sort_by(&:priority).each { |e| e.tick(self) }
  end

  def add_effect!(effect_class)
    @effects << effect_class.new
  end

  def remove_effect!(effect)
    @effects.delete(effect)
  end
end

class WizardSimulator
  def initialize(boss)
    @boss = boss
  end

  def winning_spell_sequences_under(max_cost, state, prev_spells = [], &block)
    Player::SPELL_COSTS.each do |spell, cost|
      next if cost > max_cost

      spells = [*prev_spells, spell]
      begin
        winning_spell_sequences_under(max_cost - cost, state.next(spell), spells, &block)
      rescue BossDead
        yield spells
      rescue PlayerDead, PlayerLost, CannotCast
        next
      end
    end
  end

  def simulate(spells, hard_mode: false)
    state = CombatState.new(Player.new, @boss.clone, hard_mode: hard_mode)
    state.simulate!(spells)
  rescue BossDead
    puts state.output
  end

  def cheapest_winning_spell_sequence(max_cost: 500, hard_mode: false)
    winning_sequences = []

    state = CombatState.new(Player.new, @boss.clone, hard_mode: hard_mode)
    winning_spell_sequences_under(max_cost, state) do |spells|
      winning_sequences << spells
    end

    return nil if winning_sequences.empty?

    winning_sequences.min_by(&Player.method(:spell_sequence_cost))
  end

  def report_cheapest_winning_spell_sequence(max_cost:, hard_mode: false)
    spells = cheapest_winning_spell_sequence(max_cost: max_cost, hard_mode: hard_mode)
    if spells
      simulate(spells)
      puts "\n*** #{Player.spell_sequence_cost(spells)}: #{spells.join(" ")}"
    else
      puts "Can't win with only #{max_cost} mana."
    end
  end
end

if defined? DATA
  boss = Boss.parse(DATA.read)
  sim = WizardSimulator.new(boss)
  sim.report_cheapest_winning_spell_sequence(max_cost: 1000)

  # This is an upper bound, but not the correct answer for part 2:
  # 1242: magic_missile shield recharge poison shield recharge poison magic_missile magic_missile magic_missile
  # TODO: shouldn't need an upper bound!
  sim.report_cheapest_winning_spell_sequence(max_cost: 1241, hard_mode: true)
end

__END__
Hit Points: 51
Damage: 9
