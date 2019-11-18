require 'date'

class Duration
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    raise "Duration can't end before it starts" if start_date > end_date
    @start_date = DateTime.parse(start_date)
    @end_date = DateTime.parse(end_date)
  end

  def seconds
    (@end_date - @start_date).numerator
  end
end
