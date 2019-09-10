require_relative 'time.lib'

class WorkedShift < Duration

    SECONDS_PER_DAY = 24 * 60 * 60      # 24h x 60m x 60s

    attr_reader :id
    
    def initialize(id, startDate, endDate)
        super(startDate, endDate)
        @id = id
        raise "The shift can't end before it starts" if @startDate > @endDate
        raise "The shift maximum duration is 24 hours" if seconds > SECONDS_PER_DAY
    end

end

module RuleType
    FIXED = "FIXED"
    DURATION = "DURATION"
end

class BillingRule

    attr_reader :id, :type, :payRate, :startTime, :endTime

    def initialize(id, type, payRate, startTime, endTime)
        @id = id
        @type = type
        @payRate = payRate
        @startTime = MyTime.new(startTime)
        @endTime = MyTime.new(endTime)
    end

    def diff
        return startTime.diff(endTime)
    end

    def payRatePerSecond
        return @payRate / (60.0 * 60.0)
    end

end

class Portion < WorkedShift

    attr_reader :session, :pay

    def initialize(shift, session, pay)
        @id = shift.id
        @startDate = shift.startDate
        @endDate = shift.endDate
        @session = session
        @pay = pay
    end

end

class BilledShift < Portion

    attr_reader :portions

    def initialize(shift)
        @id = shift.id
        @startDate = shift.startDate
        @endDate = shift.endDate
        @session = 0
        @pay = 0.0
        @portions = []
    end

    def apply(rules)

        session = 0
        pay = 0.0

        rules.each { |rule|

            if rule.type == RuleType::FIXED

                if rule.startTime < rule.endTime         
                    seconds = rule.diff
                else
                    seconds = MyTime::FIRST.diff(rule.startTime) + rule.endTime.diff(MyTime::LAST)
                end

                portion = Portion.new(itself, seconds, seconds * rule.payRatePerSecond)

                itself.portions << portion

            else

                puts "pendiente"

            end


        }

    end

end

