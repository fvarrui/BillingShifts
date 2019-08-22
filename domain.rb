require 'date'

class Time

    attr_reader :hour, :minutes
    
    def initialize(time)
        time = time.split(":")
        @hour = time[0].to_i
        @minutes = time[1].to_i
        raise "Invalid time" if !(0..23).include?(@hour) || !(0..59).include?(@minutes)
    end

end    

class Duration

    attr_reader :startDate, :endDate

    def initialize(startDate, endDate)
        @startDate = DateTime.parse(startDate)
        @endDate = DateTime.parse(endDate)
    end

    def seconds
        (@endDate - @startDate).numerator
    end

end

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

module BillingType
    FIXED = "FIXED"
    DURATION = "DURATION"
end

class BillingRule

    attr_reader :id, :type, :payRate, :startTime, :endTime

    def initialize(id, type, payRate, startTime, endTime)
        @id = id
        @type = type
        @payRate = payRate
        @startTime = Time.new(startTime)
        @endTime = Time.new(endTime)
    end

end

class BilledShift
end

class Portion

    def initialize(id, startTime, endTime, session, pay)
        @id = id
        @startTime = startTime
        @endTime = endTime
        @session = session
        @pay = pay
    end

end