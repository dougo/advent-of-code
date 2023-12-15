require 'test-helper'
require '2023/day-15-lens-library'

class TestLensLibrary < Minitest::Test
  def setup
    @subject = LensLibrary.parse <<END
rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
END
  end

  def test_hash_algorithm
    assert_equal 52, LensLibrary.hash_algorithm('HASH')
  end

  def test_hash_results
    assert_equal [30, 253, 97, 47, 14, 180, 9, 197, 48, 214, 231], @subject.hash_results
  end

  def test_sum_of_hash_results
    assert_equal 1320, @subject.sum_of_hash_results
  end

  def test_total_focusing_power
    assert_equal 145, @subject.total_focusing_power
  end
end
