require 'test-helper'
require '2023/day-25-snowverload'

class TestSnowverload < Minitest::Test
  def setup
    @input = <<END
jqt: rhn xhk nvd
rsh: frs pzl lsr
xhk: hfx
cmg: qnr nvd lhk bvb
rhn: xhk bvb hfx
bvb: xhk hfx
pzl: lsr hfx nvd
qnr: nvd
ntq: jqt hfx bvb xhk
nvd: lhk
lsr: lhk
rzs: qnr cmg lsr rsh
frs: qnr lhk lsr
END
    @subject = Snowverload.parse(@input)
  end

  def test_product_disconnected_group_sizes
    assert_equal 54, @subject.product_disconnected_group_sizes
  end
end
