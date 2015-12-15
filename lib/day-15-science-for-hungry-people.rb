=begin

--- Day 15: Science for Hungry People ---

Today, you set out on the task of perfecting your milk-dunking cookie recipe. All you have to do is find the right
balance of ingredients.

Your recipe leaves room for exactly 100 teaspoons of ingredients. You make a list of the remaining ingredients you
could use to finish the recipe (your puzzle input) and their properties per teaspoon:

 - capacity (how well it helps the cookie absorb milk)
 - durability (how well it keeps the cookie intact when full of milk)
 - flavor (how tasty it makes the cookie)
 - texture (how it improves the feel of the cookie)
 - calories (how many calories it adds to the cookie)

You can only measure ingredients in whole-teaspoon amounts accurately, and you have to be accurate so you can
reproduce your results in the future. The total score of a cookie can be found by adding up each of the properties
(negative totals become 0) and then multiplying together everything except calories.

For instance, suppose you have these two ingredients:

 - Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
 - Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3

Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each
ingredient must add up to 100) would result in a cookie with the following properties:

 - A capacity of 44*-1 + 56*2 = 68
 - A durability of 44*-2 + 56*3 = 80
 - A flavor of 44*6 + 56*-2 = 152
 - A texture of 44*3 + 56*-1 = 76

Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of 62842880,
which happens to be the best score possible given these ingredients. If any properties had produced a negative
total, it would have instead become zero, causing the whole score to multiply to zero.

Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie
you can make?

--- Part Two ---

Your cookie recipe becomes wildly popular! Someone asks if you can make another recipe that has exactly 500
calories per cookie (so they can use it as a meal replacement). Keep the rest of your award-winning process the
same (100 teaspoons, same ingredients, same scoring system).

For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60 teaspoons
of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500. The total score would go
down, though: only 57600000, the best you can do in such trying circumstances.

Given the ingredients in your kitchen and their properties, what is the total score of the highest-scoring cookie
you can make with a calorie total of 500?

=end

require 'set'

class Kitchen
  def initialize(input)
    ingredients = input.split("\n").map(&Ingredient.method(:new))
    @ingredients = ingredients.map(&:name).zip(ingredients).to_h # aka ingredients.index_by &:name in Rails...
    @property_names = Set.new
    @ingredients.values.each { |i| @property_names.merge(i.properties.keys) }
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
      @amounts.map { |name, amount| @kitchen.ingredient(name)[prop] * amount }.reduce(:+)
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
