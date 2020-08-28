require "hop_timer/version"
require 'benchmark'

module HopTimer
  TITLES = "user system total real".split(' ').freeze
  TIME_VALUES = %i[string number float].freeze
  TABLE_ELEMENTS = {
    top_center: "┬",
    top_right: "┐",
    mid_center: "┼",
    mid_right: "┤",
    bot_center: "┴",
    bot_right: "┘",

    top_divider: '┌',
    top_row: "|",
    mid_divider: "├",
    bot_row: "|",
    bot_divider: "└"
  }.freeze

  class CheckPoint
    attr_reader :name, :r_time, :u_time, :s_time, :cu_time, :cs_time

    def initialize(name)
      name_validation(name)

      @name = name
      p_times = Process.times
      @r_time = Time.now
      @u_time = p_times.utime
      @s_time = p_times.stime
      @cu_time = p_times.cutime
      @cs_time = p_times.cstime
    end

    def -(other)
      time_diff_set = {}

      time_diff_set[:r_diff] = r_time - other.r_time
      time_diff_set[:u_diff] = u_time - other.u_time
      time_diff_set[:s_diff] = s_time - other.s_time
      time_diff_set[:cu_diff] = cu_time - other.cu_time
      time_diff_set[:cs_diff] = cs_time - other.cs_time

      time_diff_set.each { |key, val| time_diff_set[key] = val.abs }
    end

    private

    def name_validation(name)
      error_message = "Use alphanumeric and underscore characters only"
      invalid_name = ArgumentError.new(error_message)
      raise invalid_name unless valid_name?(name)
    end

    def valid_name?(name)
      name == name.gsub(/[^a-z0-9_]/, '')
    end
  end

  def self.eval(check_point1, check_point2, time_value = :string)
    time_value_validation(time_value)

    time_diff = check_point1 - check_point2

    udiff = time_diff[:u_diff]
    sdiff = time_diff[:s_diff]
    cudiff = time_diff[:cu_diff]
    csdiff = time_diff[:cs_diff]
    realdiff = time_diff[:r_diff]

    report = Benchmark::Tms.new(udiff, sdiff, cudiff, csdiff, realdiff).to_s

    values = report_to_values(report)

    log_table(values, check_point1.name, check_point2.name)

    times_to_hash(values, time_value)
  end

  def self.time_value_validation(value_type)
    error_message = "time value can be :string or :float/:number"
    new_error = ArgumentError.new(error_message)

    raise new_error unless TIME_VALUES.include?(value_type)
  end

  def self.log_table(times, name1, name2)
    max_width = (times.map(&:length).max + 2)
    title = set_title(name1, name2, max_width)

    top_divider = TABLE_ELEMENTS[:top_divider]
    top_row = TABLE_ELEMENTS[:top_row]
    mid_divider = TABLE_ELEMENTS[:mid_divider]
    bot_row = TABLE_ELEMENTS[:bot_row]
    bot_divider = TABLE_ELEMENTS[:bot_divider]

    times.each_with_index do |val, i|
      top_divider << ("-" * max_width)
      mid_divider << ("-" * max_width)
      bot_divider << ("-" * max_width)

      if i == (times.length - 1)
        top_divider << TABLE_ELEMENTS[:top_right]
        mid_divider << TABLE_ELEMENTS[:mid_right]
        bot_divider << TABLE_ELEMENTS[:bot_right]
      else
        top_divider << TABLE_ELEMENTS[:top_center]
        mid_divider << TABLE_ELEMENTS[:mid_center]
        bot_divider << TABLE_ELEMENTS[:bot_center]
      end

      top_row << TITLES[i].center(max_width) + "|"
      bot_row << val.center(max_width) + "|"
    end

    log_and_enter(title, top_divider, top_row, mid_divider, bot_row, bot_divider)
  end

  def self.set_title(name1, name2, width)
    message = "Runtime between #{name1} and #{name2}"
    width = (width * 4) + 5

    message.center(width, "=")
  end

  def self.log_and_enter(*lines)
    lines.each { |line| puts line + "\n" }
  end

  def self.report_to_values(report)
    values = report.to_s.gsub(/(\(|\))/, '').split(' ')

    values[-1] = values[-1] + "(s)"

    values
  end

  def self.times_to_hash(times, value_type)
    times_hash = {}

    TITLES.each_with_index do |title, i|
      val = i == (TITLES.length - 1) ? times[i][0..-4] : times[i]

      output_val = case value_type
                   when :string
                     val
                   else
                     str_to_float(val)
                   end

      times_hash[title] = output_val
    end

    times_hash
  end

  def self.str_to_float(str)
    str.to_f / 1_000_000
  end

  private_constant :TITLES, :TIME_VALUES, :TABLE_ELEMENTS

  private_class_method :time_value_validation,
                       :log_table,
                       :log_and_enter,
                       :report_to_values,
                       :times_to_hash,
                       :str_to_float,
                       :set_title
end
