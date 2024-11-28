require 'rails_helper'

RSpec.describe "GET /tickets/:id/logs", type: :request do
  let!(:status) { create(:status, name: "Open") } # Crea un estado para el ticket
  let!(:ticket) { create(:ticket, status: status) } # Crea un ticket con un estado
  let!(:log1) { create(:ticket_log, ticket: ticket, status_id: status.id) } # Crea un log para el ticket

  context "when the ticket exists and has logs" do
    it "returns the history of the ticket" do
      get "/tickets/#{ticket.id}/logs" # Endpoint del método logs

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      # Verifica que el ID del ticket sea correcto
      expect(json["ticket_id"]).to eq(ticket.id)

      # Verifica que haya al menos un log
      expect(json["history"].size).to eq(1)

      # Verifica la estructura del primer log
      first_log = json["history"].first
      expect(first_log).to include(
        "id" => log1.id,
        "Status" => status.name,
        "changed_at" => log1.created_at.as_json,
        "event_id" => ticket.event_id
      )
    end
  end

  context "when the ticket exists but has no logs" do
    it "returns a message indicating no logs available" do
      # Elimina los logs del ticket para esta prueba
      ticket.ticket_logs.destroy_all

      get "/tickets/#{ticket.id}/logs"

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      # La historia debe estar vacía
      expect(json["history"]).to be_empty
    end
  end

  context "when the ticket does not exist" do
    it "returns an error" do
      get "/tickets/9999/logs" # Un ID que no existe

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)

      # Verifica que se retorne el error adecuado
      expect(json["error"]).to eq("Ticket not found")
    end
  end
end
