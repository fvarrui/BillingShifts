#!/usr/bin/env ruby

require_relative 'lib/worked_shift'
require_relative 'lib/billing_rule'
require_relative 'lib/billed_shift'

shift = WorkedShift.new(1, "2019-08-01 08:00:00", "2019-08-01 14:00:00")
rule1 = BillingRule.new(1, :fixed, 10.0, "09:00", "11:00")
rule2 = BillingRule.new(2, :fixed, 25.0, "23:00", "01:00")
billed = BilledShift.new(shift)

billed.apply([ rule1, rule2 ])
