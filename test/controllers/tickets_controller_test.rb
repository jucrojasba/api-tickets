require_relative "../test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  fixtures :statuses, :tickets

  setup do
    @ticket = Ticket.create!(event_id: 1, expire_date: Date.tomorrow, status_id: statuses(:available).id, serial_ticket: SecureRandom.hex(8))
    @new_status = Status.create!(name: "reserved")
  end

  test "should update ticket status" do
    patch ticket_status_path(@ticket), params: { new_status_id: @new_status.id }
    assert_response :success

    @ticket.reload
    assert_equal @new_status.id, @ticket.status_id
    assert_includes @ticket.ticket_logs.map(&:status_id), @new_status.id
  end

  test "should not update ticket to invalid status" do
    patch ticket_status_path(@ticket), params: { new_status_id: Status.create!(name: "sold").id }
    assert_response :unprocessable_entity
    assert_equal "Invalid status change", json_response["error"]

    @ticket.reload
    assert_not_equal Status.find_by(name: "sold").id, @ticket.status_id
  end
end

