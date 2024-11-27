require 'rails_helper'

RSpec.describe "Ticket Logs Endpoint", type: :request do
  let!(:status) { Status.create!(name: "available") } # Crea un estado para los tickets
  let!(:ticket) { Ticket.create!(event_id: 1, expire_date: "2024-11-25", status_id: 2, serial_ticket: "xyz789") } # Crea un ticket válido

  context "when the ticket exists and has logs" do
    let!(:log1) { TicketLog.create!(ticket: ticket, status_id: 2, created_at: 2.hours.ago) }
    let!(:log2) { TicketLog.create!(ticket: ticket, status_id: 1, created_at: 1.hour.ago) }

    it "returns the history of the ticket" do
      get "/tickets/#{ticket.id}/logs"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["history"].size).to eq(2)
    end
  end

  context "when the ticket has no logs" do
    it "returns a message indicating no logs available" do
      get "/tickets/#{ticket.id}/logs"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["history"]).to eq([])
    end
  end
end
