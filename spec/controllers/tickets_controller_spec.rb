# spec/controllers/tickets_controller_spec.rb

require 'rails_helper'

RSpec.describe TicketsController, type: :controller do
  describe "GET #index" do
  context "when there are tickets" do
    let!(:tickets) { create_list(:ticket, 3) }

    it "returns a successful response" do
      get :index
      expect(response).to have_http_status(:ok)
    end

    it "returns all tickets" do
      get :index
      tickets_response = JSON.parse(response.body)
      expect(tickets_response.size).to eq(3)
      expect(tickets_response.map { |t| t['id'] }).to match_array(tickets.pluck(:id))
    end
  end

  context "when there are no tickets" do
    it "returns an empty array" do
      get :index
      tickets_response = JSON.parse(response.body)
      expect(tickets_response).to eq([])
    end
  end
end

  describe "PATCH #update_status" do
  let(:available_status) { create(:status, :available) }
  let(:sold_status) { create(:status, :sold) }
  let(:ticket) { create(:ticket, status: available_status) }

  context "when the status is valid" do
    it "updates the ticket's status" do
      patch :update_status, params: { ticket_id: ticket.id, new_status_id: sold_status.id }

      ticket.reload
      expect(ticket.status).to eq(sold_status)              # Asegúrate de que el estado se actualizó
      expect(response).to have_http_status(:ok)             # Comprueba que la respuesta sea 200 OK
      json_response = JSON.parse(response.body)             # Parsear el JSON
      expect(json_response["status_id"]).to eq(sold_status.id) # Verifica los valores en la respuesta
    end
  end

  context "when the status is invalid" do
    it "raises a RecordNotFound error" do
      expect {
        patch :update_status, params: { ticket_id: ticket.id, new_status_id: -1 }
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end


  # Tests for GET #show action
  describe "GET #show" do
  let(:ticket) { create(:ticket) }

  context "when the ticket exists" do
    it "returns a successful response" do
      get :show, params: { id: ticket.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(ticket.id)
    end

    it "returns the correct ticket data" do
      get :show, params: { id: ticket.id }
      ticket_data = JSON.parse(response.body)
      expect(ticket_data['id']).to eq(ticket.id)
      expect(ticket_data['event_id']).to eq(ticket.event_id)
    end
  end

    context "when the ticket does not exist" do
      it "returns a 404 not found response" do
        get :show, params: { id: -1 }
        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Ticket not found')
      end
    end
  end
end
