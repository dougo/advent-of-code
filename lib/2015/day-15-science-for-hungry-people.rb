require_relative '../util'

class Kitchen
  def initialize(input)
    @ingredients = input.split("\n").map(&Ingredient.method(:new)).index_by &:name
    @property_names = @ingredients.values.flat_map { |i| i.properties.keys }.to_set
  end

  attr_reader :property_names

  def ingredient(name)
    @ingredients[name]
  end

  class Ingredient
    def initialize(spec)
      @name, props = spec.split(':')
      @properties = props.split(',').map do |prop|
        name, value = prop.strip.split(' ')
        [name, value.to_i]
      end.to_h
    end

    attr_reader :name, :properties

    def [](name)
      @properties[name]
    end
  end

  def cookie(amounts)
    Cookie.new(self, amounts)
  end

  class Cookie
    def initialize(kitchen, amounts)
      @kitchen = kitchen
      @amounts = amounts
    end

    def property(prop)
      @amounts.sum { |name, amount| @kitchen.ingredient(name)[prop] * amount }
    end

    def calories
      property('calories')
    end

    def score
      props = @kitchen.property_names - %w(calories)
      props.map { |prop| [0, property(prop)].max }.reduce(:*)
    end

    def add(amounts)
      self.class.new(@kitchen, @amounts.merge(amounts))
    end
  end

  def cookies(total_tsp = 100, ingredients = @ingredients.keys)
    ingr, *rest = ingredients
    if rest.empty?
      [cookie(ingr => total_tsp)]
    else
      (0..total_tsp).flat_map do |tsp|
        cookies(total_tsp - tsp, rest).map { |c| c.add(ingr => tsp) }
      end
    end
  end

  def best_cookie(cals = nil)
    (cals ? cookies.select { |c| c.calories == cals } : cookies).max_by &:score
  end
end

if defined? DATA
  kitchen = Kitchen.new(DATA.read.chomp)
  puts kitchen.best_cookie.score
  puts kitchen.best_cookie(500).score
end

__END__
Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8
