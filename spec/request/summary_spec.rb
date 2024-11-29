require 'rails_helper'

RSpec.describe "TicketsController", type: :request do
  describe "GET #summary" do
    let(:event_id) { 1 }

    context "cuando hay tickets para el evento" do
      before do
        # Deshabilitar claves foráneas en SQLite (opcional, si usas SQLite)
        ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = OFF")

        # Limpieza de datos
        TicketLog.delete_all
        Ticket.delete_all
        Status.delete_all
        ActiveRecord::Base.connection.execute("PRAGMA foreign_keys = ON")
        available_status = create(:status, name: "available")
        reserved_status = create(:status, name: "reserved")
        sold_status = create(:status, name: "sold")
        canceled_status = create(:status, name: "canceled")

        create_list(:ticket, 2, event_id: event_id, status: available_status)
        create_list(:ticket, 3, event_id: event_id, status: reserved_status)
        create_list(:ticket, 4, event_id: event_id, status: sold_status)
        create_list(:ticket, 1, event_id: event_id, status: canceled_status)
      end

      it "retorna el resumen de los tickets" do
        get "/tickets/summary", params: { event_id: event_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["available_tickets"]).to eq(2)
        expect(json_response["reserved_tickets"]).to eq(3)
        expect(json_response["sold_tickets"]).to eq(4)
        expect(json_response["canceled_tickets"]).to eq(1)
        expect(json_response["total_tickets"]).to eq(10)
      end
    end

    context "cuando hay tickets para el evento" do
      before do
        Ticket.delete_all
        Status.delete_all

        available_status = create(:status, name: "available")
        reserved_status = create(:status, name: "reserved")
        sold_status = create(:status, name: "sold")
        canceled_status = create(:status, name: "canceled")

        create_list(:ticket, 2, event_id: event_id, status: available_status)
        create_list(:ticket, 3, event_id: event_id, status: reserved_status)
        create_list(:ticket, 4, event_id: event_id, status: sold_status)
        create_list(:ticket, 1, event_id: event_id, status: canceled_status)
      end

      it "retorna el resumen de los tickets" do
        get "/tickets/summary", params: { event_id: event_id }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["available_tickets"]).to eq(2)
        expect(json_response["reserved_tickets"]).to eq(3)
        expect(json_response["sold_tickets"]).to eq(4)
        expect(json_response["canceled_tickets"]).to eq(1)
        expect(json_response["total_tickets"]).to eq(10)
      end
    end
  end
end
