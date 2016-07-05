require "test_helper"

class EventTest < ActiveSupport::TestCase
  def event
    @event ||= Event.new
  end

  test "valid event" do
    event.start_date = Date.today
    event.end_date = Date.today + 1
    assert event.valid?
  end

  test "start date required" do
    event.start_date = nil
    refute event.valid?
    refute event.errors[:start_date].empty?
  end

  test "end date required" do
    event.end_date = nil
    refute event.valid?
    refute event.errors[:end_date].empty?
  end

  test "start after end invalid" do
    event.start_date = Date.today
    event.end_date = Date.today - 1
    refute event.valid?
    refute event.errors[:end_date].empty?
  end

  test "#days_in_week" do
    # Middle of the week
    event.start_date = Date.parse('2016-07-05')
    event.end_date = Date.parse('2016-07-07')
    assert_equal 3, event.days_in_week
    # Overflow into next week
    event.end_date = Date.parse('2016-07-14')
    assert_equal 6, event.days_in_week
    # Days in next week
    assert_equal 4, event.days_in_week(Date.parse('2016-07-11'))
    # One day event
    event.end_date = Date.parse('2016-07-05')
    assert_equal 1, event.days_in_week
  end
end
