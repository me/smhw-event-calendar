require "test_helper"

class EventFlowTest < ActionDispatch::IntegrationTest
  # def test_create
  #   post events_path, params: { event: event_params }
  #   assert_response :redirect
  #   follow_redirect!
  #   assert_response :success
  #   assert_select "h2", event_params[:description]
  # end

  private

  def event_params
    {
      start_date: Date.today.to_s,
      end_date: (Date.today + 1).to_s,
      description: 'Test Event'
    }
  end
end
