class Api::V1::TicketController < ApplicationController
  def summary
    event_id = params[:event_id]# params

    # searching
    tickets = Ticket.where(event_id: event_id)

    # json REsponse
    render json: {# TODOAdd ticket required calcs
      event_id: event_id,
      total_tickets: tickets.count,
      sold_tickets: tickets.where(status: "sold").count,
      available_tickets: tickets.where(status: "available").count
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end
end
