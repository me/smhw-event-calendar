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
end
