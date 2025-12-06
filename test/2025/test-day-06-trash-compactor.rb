require 'test-helper'
require '2025/day-06-trash-compactor'

class TestTrashCompactor < Minitest::Test
  def setup
    @input = <<END
123 328  51 64 
 45 64  387 23 
  6 98  215 314
*   +   *   +  
END
    @subject = TrashCompactor.parse(@input)
  end

  def test_grand_total
    assert_equal 4277556, @subject.grand_total
  end
end
