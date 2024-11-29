# spec/controllers/tickets_controller_spec.rb

require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  # Tests for GET #index action
  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end
  end

  # Tests for PATCH #update_status action
  describe "PATCH #update_status" do
    context "when the status is valid" do
      it "updates the ticket's status" do
        patch :update_status, params: { ticket_id: ticket.id, new_status_id: sold_status.id }

        ticket.reload  # Reload ticket from the DB to get updated values
        expect(ticket.status).to eq(sold_status)  # Ensure the status was updated correctly
        expect(response).to redirect_to(ticket_path(ticket))  # Ensure it's redirected as expected
      end
    end

    context "when the status is invalid" do
      it "does not update the ticket's status" do
        patch :update_status, params: { ticket_id: ticket.id, new_status_id: nil }  # Invalid status ID

        ticket.reload
        expect(ticket.status).not_to eq(nil)  # The ticket status should remain the same
        expect(response).to have_http_status(:unprocessable_entity)  # Expect an unprocessable entity response
      end
    end
  end

  # Tests for GET #show action
  describe "GET #show" do
    let(:ticket) { create(:ticket) }

    it "returns a successful response" do
      get :show, params: { id: ticket.id }
      expect(response).to be_successful
    end
  end
end
