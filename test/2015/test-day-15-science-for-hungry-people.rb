require 'test-helper'
require '2015/day-15-science-for-hungry-people'

class TestDay15ScienceForHungryPeople < Minitest::Test
  def setup
    @input = <<END
Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3
END
    @subject = Kitchen.new(@input)
  end

  def test_ingredients
    butterscotch = @subject.ingredient('Butterscotch')
    assert_equal 6, butterscotch['flavor']
    assert_equal (-1), butterscotch['capacity']
    cinnamon = @subject.ingredient('Cinnamon')
    assert_equal (-1), cinnamon['texture']
    assert_equal 3, cinnamon['calories']
  end

  def test_cookie
    # Then, choosing to use 44 teaspoons of butterscotch and 56 teaspoons of cinnamon (because the amounts of each
    # ingredient must add up to 100) would result in a cookie with the following properties:
    cookie = @subject.cookie('Butterscotch' => 44, 'Cinnamon' => 56)

    #  - A capacity of 44*-1 + 56*2 = 68
    assert_equal 68, cookie.property('capacity')

    #  - A durability of 44*-2 + 56*3 = 80
    assert_equal 80, cookie.property('durability')

    #  - A flavor of 44*6 + 56*-2 = 152
    assert_equal 152, cookie.property('flavor')

    #  - A texture of 44*3 + 56*-1 = 76
    assert_equal 76, cookie.property('texture')

    # Multiplying these together (68 * 80 * 152 * 76, ignoring calories for now) results in a total score of
    # 62842880, which happens to be the best score possible given these ingredients.
    assert_equal 62842880, cookie.score
    assert_equal 62842880, @subject.best_cookie.score
  end

  def test_cookies
    cookies = @subject.cookies(2)
    assert_equal 3, cookies.length
    assert_equal 6,  cookies[0].calories # 0 butterscotch, 2 cinnamon
    assert_equal 11, cookies[1].calories # 1 butterscotch, 1 cinnamon
    assert_equal 16, cookies[2].calories # 2 butterscotch, 0 cinnamon
  end

  def test_max_score_fixed_calories
    # For example, given the ingredients above, if you had instead selected 40 teaspoons of butterscotch and 60
    # teaspoons of cinnamon (which still adds to 100), the total calorie count would be 40*8 + 60*3 = 500.
    cookie = @subject.cookie('Butterscotch' => 40, 'Cinnamon' => 60)
    assert_equal 500, cookie.calories

    # The total score would go down, though: only 57600000, the best you can do in such trying circumstances.
    assert_equal 57600000, @subject.best_cookie(500).score
  end
end
