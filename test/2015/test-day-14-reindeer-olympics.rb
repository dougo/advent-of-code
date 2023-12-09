require 'test-helper'
require '2015/day-14-reindeer-olympics'

class TestDay14ReindeedOlympics < Minitest::Test
  def setup
    @input = <<END
Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.
Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.
END
    @subject = ReindeerOlympics.new(@input)
  end

  def test_distance
    comet = @subject['Comet']
    dancer = @subject['Dancer']

    # After one second, Comet has gone 14 km, while Dancer has gone 16 km.
    assert_equal 14, comet.distance(1)
    assert_equal 16, dancer.distance(1)

    # After ten seconds, Comet has gone 140 km, while Dancer has gone 160 km.
    assert_equal 140, comet.distance(10)
    assert_equal 160, dancer.distance(10)

    # On the eleventh second, Comet begins resting (staying at 140 km), and Dancer continues on for a total
    # distance of 176 km.
    assert_equal 140, comet.distance(11)
    assert_equal 176, dancer.distance(11)

    # On the 12th second, both reindeer are resting.
    assert_equal 140, comet.distance(12)
    assert_equal 176, dancer.distance(12)

    # They continue to rest until the 138th second, when Comet flies for another ten seconds.
    assert_equal 140 + 140, comet.distance(138 + 10)
    assert_equal 176, dancer.distance(138 + 10)

    # On the 174th second, Dancer flies for another 11 seconds.
    assert_equal 176 + 176, dancer.distance(174 + 11)

    # In this example, after the 1000th second, both reindeer are resting, and Comet is in the lead at 1120 km
    # (poor Dancer has only gotten 1056 km by that point).
    assert_equal 1120, comet.distance(1000)
    assert_equal 1056, dancer.distance(1000)

    # So, in this situation, Comet would win (if the race ended at 1000 seconds).
    assert_equal 1120, @subject.winner_distance(1000)
  end

  def test_winner_points
    # Given the example reindeer from above, after the first second, Dancer is in the lead and gets one point.
    assert_equal 1, @subject.points(1)['Dancer']

    # He stays in the lead until several seconds into Comet's second burst: after the 140th second, Comet pulls into
    # the lead and gets his first point.
    assert_equal 1, @subject.points(140)['Comet']

    # Of course, since Dancer had been in the lead for the 139 seconds before that, he has accumulated 139 points
    # by the 140th second.
    assert_equal 139, @subject.points(140)['Dancer']

    # After the 1000th second, Dancer has accumulated 689 points, while poor Comet, our old champion, only has 312.
    assert_equal 689, @subject.points(1000)['Dancer']
    assert_equal 312, @subject.points(1000)['Comet']

    # So, with the new scoring system, Dancer would win (if the race ended at 1000 seconds).
    assert_equal 689, @subject.winner_points(1000)
  end
end
