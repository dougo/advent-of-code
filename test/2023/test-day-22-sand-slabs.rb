require 'test-helper'
require '2023/day-22-sand-slabs'

class TestSandSlabs < Minitest::Test
  def setup
    @input = <<END
1,0,1~1,2,1
0,0,2~2,0,2
0,2,3~2,2,3
0,0,4~0,2,4
2,0,5~2,2,5
0,1,6~2,1,6
1,1,8~1,1,9
END
    @subject = SandSlabs.parse(@input)

    # A supports B and C;
    # C supports D;
    # B and D both support E.
    # EE
    # BD
    # BC
    # AA
    @input2 = <<END
0,0,1~0,1,1
0,0,2~0,0,3
0,1,2~0,1,2
0,1,3~0,1,3
0,0,4~0,1,4
END
    @subject2 = SandSlabs.parse(@input2)
  end

  def test_num_disintegrateable_bricks
    assert_equal 5, @subject.num_disintegrateable_bricks
    assert_equal 3, @subject2.num_disintegrateable_bricks # B, D, E
  end

  def test_sum_other_bricks_that_would_fall
    assert_equal 7, @subject.sum_other_bricks_that_would_fall
    assert_equal 5, @subject2.sum_other_bricks_that_would_fall # A=4, C=1
  end
end
