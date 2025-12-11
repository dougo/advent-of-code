require 'test-helper'
require '2025/day-11-reactor'

class TestReactor < Minitest::Test
  def setup
    @input = <<END
aaa: you hhh
you: bbb ccc
bbb: ddd eee
ccc: ddd eee fff
ddd: ggg
eee: out
fff: out
ggg: out
hhh: ccc fff iii
iii: out
END
    @subject = Reactor.parse(@input)
    @input2 = <<END
svr: aaa bbb
aaa: fft
fft: ccc
bbb: tty
tty: ccc
ccc: ddd eee
ddd: hub
hub: fff
eee: dac
dac: fff
fff: ggg hhh
ggg: out
hhh: out
END
    @subject2 = Reactor.parse(@input2)
  end

  def test_num_paths
    assert_equal 5, @subject.num_paths
  end

  def test_num_paths_visiting_dac_and_fft
    assert_equal 2, @subject2.num_paths_visiting_dac_and_fft
  end
end
