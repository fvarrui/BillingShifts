
class MyTime
  attr_reader :hour, :minutes

  def initialize(time)
    time = time.split(':')
    @hour = time[0].to_i
    @minutes = time[1].to_i
    raise 'Invalid time' if !(0..23).include?(@hour) ||
                            !(0..59).include?(@minutes)
  end

  def to_minutes
    (@hour * 60) + @minutes
  end

  def to_seconds
    to_minutes * 60
  end

  def compare(time)
    if time.to_minutes < to_minutes
      return 1
    elsif time.to_minutes > to_minutes
      return -1
    end
    0
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
    format("%02d:%02d", @hour, @minutes)
  end

  def self.first
    MyTime.new("00:00")
  end

  def self.last
    MyTime.new("23:59")
  end
end
