require 'date'

class MyTime

    attr_reader :hour, :minutes
    
    def initialize(time)
        time = time.split(":")
        @hour = time[0].to_i
        @minutes = time[1].to_i
        raise "Invalid time" if !(0..23).include?(@hour) || !(0..59).include?(@minutes)
    end

    def to_minutes
        return (@hour * 60) + @minutes
    end

    def to_seconds
        return to_minutes * 60
    end

    def compare(time)
        if time.to_minutes < to_minutes
            return +1 
        elsif time.to_minutes > to_minutes
            return -1 
        else
            return 0
        end
    end

    def <=(time)
        compare(time) <= 0
    end

    def >=(time)
        compare(time) >= 0
    end

    def <(time)
        compare(time) < 0
    end

    def >(time)
        compare(time) > 0
    end

    def ==(time)
        compare(time) == 0
    end

    def !=(time)
        compare(time) != 0
    end

    def diff(time)
        return time.to_seconds - to_seconds
    end

    def to_s
        return format("%02d:%02d", @hour, @minutes)
    end

    FIRST = MyTime.new("00:00")
    LAST = MyTime.new("23:59")

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
