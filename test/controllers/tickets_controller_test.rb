require "test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  test "no existing id" do
    get "events/#{999}/tickets/summary"
    assert_response :not_found
    response_body = JSON.parse(response.body)
    assert_equal "Event not found", response_body["error"]
  end
  # test "the truth" do
  #   assert true
  # end
end
