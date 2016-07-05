class EventsController < ApplicationController
  def index
    day = params[:week].present? ? Date.parse(params[:week]) : Date.today
    @new_event = Event.new
    @week_start = day.beginning_of_week
    @week_end = @week_start + 6
    events = Event.where(
      "start_date <= ? and end_date >= ?", @week_end, @week_start
    )
    @events_by_day = Hash.new(){ |h, k| h[k] = [] }
    events.each do |event|
      day = [@week_start, event.start_date].max
      @events_by_day[day] << event
    end
  end

  def create
    start_date = date_from_params(params[:event], :start_date)
    end_date = date_from_params(params[:event], :end_date)
    @new_event = Event.create(
      start_date: start_date,
      end_date: end_date,
      description: params[:event][:description]
    )
    if @new_event.valid?
      respond_to do |format|
        format.html { redirect_to action: :index, week: start_date.beginning_of_week }
        format.js { render json: @new_event }
      end
    else
      respond_to do |format|
        format.html { render 'index' }
        format.js { render json: {errors: @new_event.errors }}
      end
    end
  end

  private

  def date_from_params(params, name)
    Date.civil(params["#{name}(1i)"].to_i,params["#{name}(2i)"].to_i,params["#{name}(3i)"].to_i)
  end

end
