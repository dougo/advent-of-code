require 'test-helper'
require '2023/day-20-pulse-propagation'

class TestPulsePropagation < Minitest::Test
  def setup
    @subject = PulsePropagation.parse <<END
broadcaster -> a, b, c
%a -> b
%b -> c
%c -> inv
&inv -> a
END

    @subject2 = PulsePropagation.parse <<END
broadcaster -> a
%a -> inv, con
&inv -> b
%b -> con
&con -> output
END

    # My puzzle input has the following four configurations in parallel (after looking at the graph in a visualizer
    # and reordering the modules by hand):

    @subject3 = PulsePropagation.parse <<END
broadcaster -> fb
%fb -> bz, tg
%tg -> cq
%cq -> jm
%jm -> vm, bz
%vm -> bz, xh
%xh -> qc
%qc -> kh, bz
%kh -> tp, bz
%tp -> rm, bz
%rm -> bz, xq
%xq -> bz, hx
%hx -> bz
&bz -> qx, cq, xh, fb, tg
&qx -> gh
&gh -> rx
END

    @subject4 = PulsePropagation.parse <<END
broadcaster -> xk
%xk -> gf, rd
%rd -> cp
%cp -> gg
%gg -> kn
%kn -> gf, tz
%tz -> rz
%rz -> qq, gf
%qq -> pt, gf
%pt -> vx
%vx -> gf, cv
%cv -> gf, kb
%kb -> gf
&gf -> tz, cd, rd, xk, pt, cp, gg
&cd -> gh
&gh -> rx
END

    @subject5 = PulsePropagation.parse <<END
broadcaster -> gr
%gr -> xz, xb
%xb -> xz, bq
%bq -> rr
%rr -> rv, xz
%rv -> mx
%mx -> mt, xz
%mt -> sj, xz
%sj -> vp
%vp -> xz, xx
%xx -> kp, xz
%kp -> xz, nj
%nj -> xz
&xz -> bq, gr, sj, rv, zf
&zf -> gh
&gh -> rx
END

    @subject6 = PulsePropagation.parse <<END
broadcaster -> vj
%vj -> hb, jj
%hb -> mj
%mj -> jj, lv
%lv -> zk
%zk -> jj, xv
%xv -> lz
%lz -> qn
%qn -> vh, jj
%vh -> gx
%gx -> jj, qv
%qv -> xr, jj
%xr -> jj
&jj -> hb, lz, rk, xv, vj, vh, lv
&rk -> gh
&gh -> rx
END
  end

  def test_pulse_product
    assert_equal 32000000, @subject.pulse_product
    assert_equal 11687500, @subject2.pulse_product
  end

  def test_num_button_presses_for_output_to_receive_low
    assert_equal 4057, @subject3.num_button_presses_for_output_to_receive_low
    assert_equal 4057*2, @subject3.num_button_presses_for_output_to_receive_low

    assert_equal 3793, @subject4.num_button_presses_for_output_to_receive_low
    assert_equal 3793*2, @subject4.num_button_presses_for_output_to_receive_low

    assert_equal 3947, @subject5.num_button_presses_for_output_to_receive_low
    assert_equal 3947*2, @subject5.num_button_presses_for_output_to_receive_low

    assert_equal 3733, @subject6.num_button_presses_for_output_to_receive_low
    assert_equal 3733*2, @subject6.num_button_presses_for_output_to_receive_low
  end
end
