require 'test-helper'
require '2023/day-6-wait-for-it'

class TestToyBoatRaces < Minitest::Test
  def setup
    @text = <<END
Time:      7  15   30
Distance:  9  40  200
END
    @subject = ToyBoatRaces.new(@text)
    @subject2 = ToyBoatRaces.new(@text, ignoring_spaces: true)
  end

  def test_race_parsing
    assert_equal [{ time: 7, distance: 9 },
                  { time: 15, distance: 40 },
                  { time: 30, distance: 200 }],
                 @subject.races.map(&:to_h)
  end

  def test_races_parsing_ignoring_spaces
    assert_equal ({ time: 71530, distance: 940200 }), @subject2.races.first.to_h
  end

  def test_times_to_equal_the_record
    times = @subject.races.first.times_to_equal_the_record
    assert_in_delta 1.697, times[0]
    assert_in_delta 5.303, times[1]
  end

  def test_times_to_beat_the_record
    # there are actually 4 different ways you could win: you could hold the button for 2, 3, 4, or 5 milliseconds
    # at the start of the race.
    # In the second race, you could hold the button for at least 4 milliseconds and at most 11 milliseconds and
    # beat the record, a total of 8 different ways to win.
    # In the third race, you could hold the button for at least 11 milliseconds and no more than 19 milliseconds
    # and still beat the record, a total of 9 ways you could win.
    assert_equal 2..5, @subject.races[0].times_to_beat_the_record
    assert_equal 4..11, @subject.races[1].times_to_beat_the_record
    assert_equal 11..19, @subject.races[2].times_to_beat_the_record
  end

  def test_product_of_ways_to_beat_the_records
    # in this example, if you multiply these values together, you get 288 (4 * 8 * 9).
    assert_equal 288, @subject.product_of_ways_to_beat_the_records

    # You could hold the button anywhere from 14 to 71516 milliseconds and beat the record, a total of 71503 ways!
    assert_equal 71503, @subject2.product_of_ways_to_beat_the_records
  end
end
