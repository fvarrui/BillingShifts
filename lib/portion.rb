require_relative 'worked_shift'

class Portion < WorkedShift
  attr_reader :session, :pay

  def initialize(shift, session, pay)
    @shift = shift
    @session = session
    @pay = pay
 end

 def id
   @shift.id
 end

 def start_date
   @shift.start_date
 end

 def end_date
   @shift.end_date
 end
end
