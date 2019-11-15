require_relative 'my_time'

class BillingRule
  attr_reader :id, :type, :pay_rate, :start_time, :end_time

  def initialize(id, type, pay_rate, start_time, end_time)
    @id = id
    @type = type
    @pay_rate = pay_rate
    @start_time = MyTime.new(start_time)
    @end_time = MyTime.new(end_time)
  end

  def diff
    start_time.diff(@end_time)
  end

  def pay_rate_per_second
    @pay_rate / (60.0 * 60.0)
  end
end
