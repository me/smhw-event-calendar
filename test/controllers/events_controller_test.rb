require "test_helper"

class EventsControllerTest < ActionController::TestCase
  test "get index" do
    get :index
    assert_response :success
  end

  test "assigns" do
    get :index, week: "2016-01-01"
    assert_equal Date.parse("2015-12-28"), assigns(:week_start)
    assert_equal Date.parse("2016-01-03"), assigns(:week_end)
    assert_equal 2, assigns(:events_by_day)[Date.parse("2016-01-01")].length
    assert_equal 1, assigns(:events_by_day)[Date.parse("2016-01-02")].length
  end

  test "events_by_day multiweek middle" do
    get :index, week: "2016-01-04"
    d = Date.parse("2016-01-04")
    assert_equal 1, assigns(:events_by_day)[d].length
    assert_equal "Multiweek", assigns(:events_by_day)[d].first.description
  end

  test "events_by_day multiweek ending" do
    get :index, week: "2016-01-25"
    d = Date.parse("2016-01-25")
    assert_equal 1, assigns(:events_by_day)[d].length
    assert_equal "Multiweek", assigns(:events_by_day)[d].first.description
  end

  test "events_by_day no events" do
    get :index, week: "2016-02-01"
    assert_equal 0, assigns(:events_by_day).reduce(0){ |s, pair| s + pair.last.length}
  end

end
