class Event < ActiveRecord::Base
  validates :start_date, presence: true
  validates :end_date, presence: true, date: { :after_or_equal_to => :start_date}

  def start_date_week
    start_date.beginning_of_week
  end

  def days_in_week(week_start=start_date_week)
    week_end = week_start + 6
    start = [start_date, week_start].max
    [week_end, end_date].min - start + 1
  end
end
