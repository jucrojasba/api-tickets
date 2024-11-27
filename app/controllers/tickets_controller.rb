class TicketsController < ApplicationController
  # GET /tickets/:ticket_id/logs
  def logs
    @ticket = Ticket.find_by(id: params[:id])

    if @ticket
      logs = @ticket.ticket_logs.select(:id, :status_id, :created_at, :updated_at)
      render json: {
        ticket_id: @ticket.id,
        history: logs.map do |log|
          {
            id: log.id,
            Status: log.status.name,
            changed_at: log.created_at
          }
        end
      }, status: :ok
    else
      render json: { error: "Ticket not found" }, status: :not_found
    end
  end

  # PATCH/PUT /tickets/:ticket_id/update_status
  def update_status
    ticket = Ticket.find_by(id: params[:ticket_id])
    new_status = Status.find_by(id: params[:new_status_id])

    if ticket.nil?
      render json: { error: "Ticket not found" }, status: :not_found
      return
    end

    if new_status.nil?
      render json: { error: "Status not found" }, status: :not_found
      return
    end

    if can_update_status?(ticket, new_status)
      ticket.status = new_status
      if ticket.save
        log_status_change(ticket, new_status)
        render json: ticket, status: :ok
      else
        render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid status change" }, status: :bad_request
    end
  end

  def summary
    event_id = params[:event_id]# params
    # searching
    tickets = Ticket.per_event(:event_id)
    # json REsponse
    if tickets.exists?
      render json: {# ticket required calcs
      event_id: event_id,
      available_tickets: tickets.where(status: "available").count,
      reserved_tickets: tickets.where(status: "reserved").count,
      sold_tickets: tickets.where(status: "sold").count,
      canceled_tickets: tickets.where(status: "canceled").count,
      total_tickets: tickets.count
      }, status: :ok
    else
      render json: { error: "Not event" }, statuts: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  private
  def set_ticket
    @ticket = Ticket.find_by(id: params[:id])
  end

  def can_update_status?(ticket, new_status)
    return false if ticket.status == new_status

    valid_transitions = {
      "New" => [ "Open" ],
      "Open" => [ "InProgress", "Resolved", "Cancelled" ],
      "InProgress" => [ "Resolved", "Cancelled" ],
      "Resolved" => [ "Closed", "Reserved" ],
      "Closed" => [ "Available", "Sold" ],
      "Cancelled" => [],
      "Reserved" => [ "Sold" ],
      "Available" => [ "Reserved", "Sold" ],
      "Sold" => []
    }

    valid_transitions[ticket.status.name]&.include?(new_status.name) || false
  end

  def log_status_change(ticket, new_status)
    ticket.ticket_logs.create(state: new_status.name, created_at: Time.current)
  end
end
