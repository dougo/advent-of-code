require_relative '../util'

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
  def self.parse(input)
    input =~ /Hit Points: (\d+)\nDamage: (\d+)\nArmor: (\d+)/
    new(hp: $1.to_i, damage: $2.to_i, armor: $3.to_i)
  end

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
    defender.hp.fdiv(damage_dealt_to(defender)).ceil
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
  boss = Character.parse(DATA.read)
  p Character.cheapest_player_that_defeats(boss).cost
  p Character.most_expensive_player_defeated_by(boss).cost
end

__END__
Hit Points: 103
Damage: 9
Armor: 2
