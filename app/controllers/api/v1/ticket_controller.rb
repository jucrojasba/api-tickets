class Api::V1::TicketController < ApplicationController
  def summary
    event_id = params[:event_id]# params
    # searching
    tickets = Ticket.per_event(:event_id)
    # json REsponse
    render json: {# ticket required calcs
    event_id: event_id,
    available_tickets: tickets.where(status: "available").count,
    reserved_tickets: tickets.where(status: "reserved").count,
    sold_tickets: tickets.where(status: "sold").count,
    canceled_tickets: tickets.where(status: "canceled").count,
    total_tickets: tickets.count
    }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end
end
