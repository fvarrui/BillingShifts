require_relative 'duration'

class WorkedShift < Duration
  SECONDS_PER_DAY = 24 * 60 * 60      # 24h x 60m x 60s
  attr_reader :id

  def initialize(id, start_date, end_date)
    super(start_date, end_date)
    @id = id
    raise "The shift maximum duration is 24 hours" if seconds > SECONDS_PER_DAY
  end
end
