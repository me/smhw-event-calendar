class EventsController < ApplicationController
  def index
    day = params[:week].present? ? Date.parse(params[:week]) : Date.today
    @week_start = day.beginning_of_week
    @week_end = @week_start + 6
    events = Event.where(
      "start_date < ? and end_date > ?", @week_end, @week_start
    )
    @events_by_day = Hash.new(){ |h, k| h[k] = [] }
    events.each do |event|
      day = [@week_start, event.start_date].max
      @events_by_day[day] << event
    end

  end

end
