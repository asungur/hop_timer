require_relative 'test_helper'

class HopTimerTest < Minitest::Test
  TIME_TYPES = "user system total real".split(' ').freeze

  def test_that_it_has_a_version_number
    refute_nil ::HopTimer::VERSION
  end

  def test_eval_two_flags
    flag1 = HopTimer::CheckPoint.new('first_flag')
    sleep 0.2
    flag2 = HopTimer::CheckPoint.new('second_flag')

    times = HopTimer.eval(flag1, flag2)

    HopTimerTest::TIME_TYPES.each do |type|
      assert_includes times.keys, type
    end
  end

  def test_eval_two_flags_reversed_order
    flag1 = HopTimer::CheckPoint.new('first_flag')
    sleep 0.2
    flag2 = HopTimer::CheckPoint.new('second_flag')

    times = HopTimer.eval(flag2, flag1, :float)

    HopTimerTest::TIME_TYPES.each do |type|
      assert_includes times.keys, type
      assert_operator times[type], :>=, 0
    end
  end

  def test_eval_invalid_num_of_inputs
    assert_raises { HopTimer::CheckPoint.new }
    assert_raises { HopTimer::CheckPoint.new('flag1', 'flag2') }
  end

  def test_eval_invalid_checkpoint_name
    assert_raises { HopTimer::CheckPoint.new(' ') }
    assert_raises { HopTimer::CheckPoint.new('flag 1') }
    assert_raises { HopTimer::CheckPoint.new('FLAG_*') }
  end

  def test_eval_output
  end

  def test_private_constants
  end

  def test_private_method_log_and_enter
  end
end
