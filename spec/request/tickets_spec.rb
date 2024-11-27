require 'rails_helper'

require 'rails_helper'

RSpec.describe "GET /tickets/:id/logs", type: :request do
  # Asegúrate de que hay datos en la base de datos antes de ejecutar las pruebas
  let(:ticket) { Ticket.first } # Toma el primer ticket
  let(:status) { ticket.status } # Obtén el status del ticket

  context "when the ticket exists and has logs" do
    it "returns the history of the ticket" do
      get "/tickets/#{ticket.id}/logs" # Endpoint del método logs

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)

      # Verifica que el ID del ticket sea correcto
      expect(json["ticket_id"]).to eq(ticket.id)

      # Verifica que haya al menos un log
      expect(json["history"].size).to be > 0

      # Verifica la estructura del primer log
      first_log = json["history"].first
      expect(first_log).to include(
        "id" => ticket.ticket_logs.first.id,
        "Status" => ticket.ticket_logs.first.status.name,
        "changed_at" => ticket.ticket_logs.first.created_at.as_json,
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
