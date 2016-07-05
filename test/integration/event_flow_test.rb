require "test_helper"

class EventFlowTest < ActionDispatch::IntegrationTest
  def test_create
    post events_path, event: event_params
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select ".event .description", event_params[:description]
  end

  private

  def event_params
    {
      description: 'Test Event'
    }.merge(date_params(:start_date, Date.today.to_s))
     .merge(date_params(:end_date, (Date.today + 1).to_s))
  end
end
