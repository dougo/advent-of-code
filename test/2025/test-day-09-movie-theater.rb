require 'test-helper'
require '2025/day-09-movie-theater'

class TestMovieTheater < Minitest::Test
  def setup
    @input = <<END
7,1
11,1
11,7
9,7
9,5
2,5
2,3
7,3
END
    @subject = MovieTheater.parse(@input)
  end

  def test_largest_rectangle_area
    assert_equal 50, @subject.largest_rectangle_area
  end

  def test_largest_rectangle_using_only_red_green_area
    assert_equal 24, @subject.largest_rectangle_using_only_red_green_area
  end
end
