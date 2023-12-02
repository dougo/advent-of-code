require 'test-helper'
require 'day-13-knights-of-the-dinner-table'

class TestDay13KnightsOfTheDinnerTable < Minitest::Test
  def setup
    @input = <<END
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
END
    @subject = HolidayFeast.new(@input)
  end

  def test_optimal_seating_arrangement
    # Then, if you seat Alice next to David, Alice would lose 2 happiness units (because David talks so much), but
    # David would gain 46 happiness units (because Alice is such a good listener), for a total change of 44.
    assert_equal (-2), @subject.happiness_change('Alice', 'David')
    assert_equal 46, @subject.happiness_change('David', 'Alice')
    assert_equal 44, @subject.total_happiness_change(%w(Alice David))

    # If you continue around the table, you could then seat Bob next to Alice (Bob gains 83, Alice gains
    # 54). Finally, seat Carol, who sits next to Bob (Carol gains 60, Bob loses 7) and David (Carol gains 55, David
    # gains 41). The arrangement looks like this:
    #
    #      +41 +46
    # +55   David    -2
    # Carol       Alice
    # +60    Bob    +54
    #      -7  +83
    #
    # After trying every other seating arrangement in this hypothetical scenario, you find that this one is the
    # most optimal, with a total change in happiness of 330.
    assert_equal 330, @subject.total_happiness_change(%w(David Alice Bob Carol))
    assert_equal 330, @subject.total_happiness_change(@subject.optimal_seating_arrangement)
    
    @subject.add_attendee('Doug')
    assert_equal 44, @subject.total_happiness_change(%w(Alice David Doug))
  end
end
