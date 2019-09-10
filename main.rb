require_relative 'domain'

shift = WorkedShift.new(1, "2019-08-01 08:00:00", "2019-08-01 14:00:00")
rule1 = BillingRule.new(1, RuleType::FIXED, 10.0, "09:00", "11:00")
rule2 = BillingRule.new(2, RuleType::FIXED, 25.0, "23:00", "01:00")
billed = BilledShift.new(shift)

billed.apply([ rule1, rule2 ])

