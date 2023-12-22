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
  end

  def test_num_disintegrateable_bricks
    assert_equal 5, @subject.num_disintegrateable_bricks
  end
end
