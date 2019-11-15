require_relative 'portion'
require_relative 'my_time'
require_relative 'billing_rule'

class BilledShift < Portion
  attr_reader :portions

  def initialize(shift)
    @shift = shift
    @session = 0
    @pay = 0.0
    @portions = []
  end

  def apply(rules)
    session = 0
    pay = 0.0
    rules.each do |rule|
      apply_rule_fixed(rule) if rule.type == :fixed
      puts "pendiente" if rule.type != :fixed
    end
  end

  private

  def apply_rule_fixed(rule)
    if rule.start_time < rule.end_time
      seconds = rule.diff
    else
      seconds = MyTime.first.diff(rule.start_time) +
                rule.end_time.diff(MyTime.last)
    end
    portion = Portion.new(@shift, seconds, seconds * rule.pay_rate_per_second)
    @portions << portion
  end
end
