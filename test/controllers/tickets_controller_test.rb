require "test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  test "no existing id" do
    get "/api/v1/ticket/#{non_exist_id}/tickets/summary"
    assert_response :not_found
    response_body = JSON.parse(response.body)
    assert_equal "Event not found", response_body["error"]
  end
  # test "the truth" do
  #   assert true
  # end
end
