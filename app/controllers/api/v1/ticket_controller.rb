class Api::V1::TicketController < ApplicationController
  def summary
    event_id = params[:event_id]

    # Aquí implementas la lógica para obtener los datos de resumen
    # Por ejemplo, suponiendo que tienes un modelo Ticket:
    tickets = Ticket.where(event_id: event_id)

    # Crea la respuesta JSON
    render json: {
      event_id: event_id,
      total_tickets: tickets.count,
      sold_tickets: tickets.where(status: "sold").count,
      available_tickets: tickets.where(status: "available").count
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end
end
