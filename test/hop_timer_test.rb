require_relative 'test_helper'

class HopTimerTest < Minitest::Test
  TIME_TYPES = "user system total real".split(' ').freeze
  PRIVATE_METHODS = [
    :time_value_validation,
    :log_table,
    :log_and_enter,
    :report_to_values,
    :times_to_hash,
    :str_to_float,
    :set_title
  ].freeze

  def setup
    @test_flag = HopTimer::CheckPoint.new('f1')
  end

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

  def test_public_methods
    assert_includes HopTimer.public_methods, :eval
  end

  def test_private_constants
    error1 = assert_raises(NameError) { HopTimer::TITLES }
    error2 = assert_raises(NameError) { HopTimer::TABLE_ELEMENTS }
    error3 = assert_raises(NameError) { HopTimer::TIME_VALUES}

    assert_equal error1.message, "private constant HopTimer::TITLES referenced"
    assert_equal error2.message, "private constant HopTimer::TABLE_ELEMENTS referenced"
    assert_equal error3.message, "private constant HopTimer::TIME_VALUES referenced"
  end

  def test_private_methods
    PRIVATE_METHODS.each do |method_name|
      assert_includes HopTimer.private_methods, method_name
    end
  end

  def test_checkpoint_private_methods
    assert_includes @test_flag.private_methods, :name_validation
    assert_includes @test_flag.private_methods, :valid_name?
  end

  def test_checkpoint_public_methods
    assert_includes @test_flag.public_methods, :-
    assert_includes @test_flag.public_methods, :name
    assert_includes @test_flag.public_methods, :r_time
    assert_includes @test_flag.public_methods, :u_time
    assert_includes @test_flag.public_methods, :s_time
    assert_includes @test_flag.public_methods, :cu_time
    assert_includes @test_flag.public_methods, :cs_time 
  end
end
