require_relative '../util'

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
    @hp, @damage = hp, damage
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
    @hp, @mana = hp, mana
    @armor = 0
  end

  attr_accessor :hp, :mana, :armor

  def to_s
    "Player has #{@hp} hit point#{@hp == 1 ? "" : "s"}, #{@armor} armor, #{@mana} mana"
  end

  def die
    raise PlayerDead
  end
end

class Effect
  def initialize(duration)
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
    puts_timer(state)
    if @timer == 0
      state.print("#{name} wears off")
      expire(state)
      state.remove_effect!(self)
      state.puts "."
    end
  end

  def puts_timer(state)
    state.puts "; its timer is now #{@timer}."
  end

  def expire(state)
  end
end

class Shield < Effect
  def puts_timer(state)
    state.puts "Shield's timer is now #{@timer}."
  end

  def expire(state)
    state.player.armor -= 7
    state.print(", decreasing armor by 7")
  end
end

class Poison < Effect
  def magic(state)
    state.print("Poison deals 3 damage")
    state.boss.take_damage!(3)
  end
end

class Recharge < Effect
  def magic(state)
    state.print("Recharge provides 101 mana")
    state.player.mana += 101
  end
end

class CombatState
  def initialize(player, boss, effects: {}, hard_mode: false)
    @player, @boss, @effects, @hard_mode = player, boss, effects, hard_mode
    @output = +''
  end

  attr_accessor :player, :boss, :output

  def next(spell)
    clone.next!(spell)
  end

  def simulate!(spells)
    spells.each(&method(:next!))

    puts("** No more spells to cast!")
  rescue BossDead
    puts ". This kills the boss, and the player wins."
    raise
  end

  def puts(str = nil)
    print(str) if str
    print("\n")
  end

  def print(str)
    @output << str
  end

  def remove_effect!(effect)
    @effects.delete(@effects.key(effect))
  end

  protected

  def next!(spell)
    puts '-- Player turn --'

    if @hard_mode
      puts "HARD MODE: Player loses 1 hit point!"
      @player.take_damage!(1)
    end

    tick

    cast_spell(spell)

    puts "\n-- Boss turn --"
    tick

    damage = [1, @boss.damage - @player.armor].max
    if @player.armor > 0
      puts "Boss attacks for #{@boss.damage} - #{@player.armor} = #{damage} damage!"
    else
      puts "Boss attacks for #{@boss.damage} damage!"
    end
    @player.take_damage!(damage)
    puts

    self
  end

  private

  def clone
    effects = @effects.map { |k,v| [k, v.clone] }.to_h
    self.class.new(@player.clone, @boss.clone, effects: effects, hard_mode: @hard_mode)
  end

  def tick
    puts "- #{@player}"
    puts "- #{@boss}"

    effects.each { |e| e.tick(self) }
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

  def spell_name(spell)
    spell == :magic_missile ? 'Magic Missile' : spell.capitalize
  end

  def cast_spell(spell)
    name = spell_name(spell)
    if @effects[spell]
      raise CannotCast, "Can't cast #{name}, an effect already exists."
    end

    if @player.mana >= SPELL_COSTS[spell]
      @player.mana -= SPELL_COSTS[spell]
      print("Player casts #{name}")
      send(spell)
      puts "."
    else
      raise PlayerLost, "** Player does not have enough mana to cast #{spell}."
    end
  end

  def magic_missile
    print(", dealing 4 damage")
    @boss.take_damage!(4)
  end

  def drain
    print(", dealing 2 damage, and healing 2 hit points")
    @boss.take_damage!(2)
    @player.hp += 2
  end

  def shield
    print(", increasing armor by 7")
    @player.armor += 7
    @effects[:shield] = Shield.new(6)
  end

  def poison
    @effects[:poison] = Poison.new(6)
  end

  def recharge
    @effects[:recharge] = Recharge.new(5)
  end

  def effects
    @effects.values_at(:shield, :poison, :recharge).compact
  end

end

class WizardSimulator
  def initialize(player: Player.new, boss:, hard_mode: false)
    @player, @boss, @hard_mode = player, boss, hard_mode
  end

  def simulate(spells)
    state = start_state
    state.simulate!(spells)
  rescue BossDead
    puts state.output
  end

  def cheapest_winning_spell_sequence(max_cost: 500)
    winning_sequences = []

    state = start_state
    winning_spell_sequences_under(max_cost, state) do |spells|
      winning_sequences << spells
    end

    return nil if winning_sequences.empty?

    winning_sequences.min_by(&CombatState.method(:spell_sequence_cost))
  end

  def report_cheapest_winning_spell_sequence(max_cost:)
    spells = cheapest_winning_spell_sequence(max_cost: max_cost)
    if spells
      simulate(spells)
      puts "\n*** #{CombatState.spell_sequence_cost(spells)}: #{spells.join(" ")}"
    else
      puts "Can't win with only #{max_cost} mana."
    end
  end

  private

  def start_state
    CombatState.new(@player.clone, @boss.clone, hard_mode: @hard_mode)
  end

  def winning_spell_sequences_under(max_cost, state, prev_spells = [], &block)
    CombatState::SPELL_COSTS.each do |spell, cost|
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
end

if defined? DATA
  boss = Boss.parse(DATA.read)
  WizardSimulator.new(boss: boss).report_cheapest_winning_spell_sequence(max_cost: 1000)

  # This is an upper bound, but not the correct answer for part 2:
  # 1242: magic_missile shield recharge poison shield recharge poison magic_missile magic_missile magic_missile
  # TODO: shouldn't need an upper bound!
  WizardSimulator.new(boss: boss, hard_mode: true).report_cheapest_winning_spell_sequence(max_cost: 1241)
end

__END__
Hit Points: 51
Damage: 9
