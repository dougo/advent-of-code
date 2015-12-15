require 'test-helper'
require 'day-15-science-for-hungry-people'

class TestDay15ScienceForHungryPeople < Minitest::Test
  def setup
    @input = <<END
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
END
    @subject = Ingredients.new(@input)
  end

  def test_ingredients
    assert_equal 6, @subject['Butterscotch']['flavor']
    assert_equal -1, @subject['Butterscotch']['capacity']
    assert_equal -1, @subject['Cinnamon']['texture']
    assert_equal 3, @subject['Cinnamon']['calories']
  end

  def test_score
    # Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each
    # ingredient must add up to 100) would result in a cookie with the following properties:
    amounts = { 'Butterscotch' => 44, 'Cinnamon' => 56 }

    #  - A capacity of 44*-1 + 56*2 = 68
    assert_equal 68, @subject.property('capacity', amounts)

    #  - A durability of 44*-2 + 56*3 = 80
    assert_equal 80, @subject.property('durability', amounts)

    #  - A flavor of 44*6 + 56*-2 = 152
    assert_equal 152, @subject.property('flavor', amounts)

    #  - A texture of 44*3 + 56*-1 = 76
    assert_equal 76, @subject.property('texture', amounts)

    # Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of
    # 62842880, which happens to be the best score possible given these ingredients.
    assert_equal 62842880, @subject.score(amounts)
    assert_equal 62842880, @subject.max_score
  end

  def test_max_score_fixed_calories
    # For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60
    # teaspoons of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500.
    amount = { 'Butterscotch' => 40, 'Cinnamon' => 60 }
    assert_equal 500, @subject.calories(amount)

    # The total score would go down, though: only 57600000, the best you can do in such trying circumstances.
    assert_equal 57600000, @subject.max_score(500)
  end
end
