class TicketsController < ApplicationController
  # GET /tickets/:ticket_id/logs
  def logs
    @ticket = Ticket.find_by(id: params[:ticket_id])
    if @ticket
      logs = ticket.ticket_logs.select(:id, :state, :created_at, :updated_at)
      render json: {
        ticket_id: ticket.id,
        history: logs.map do |log|
          {
            id: log.id,
            state: log.state,
            changed_at: log.created_at
          }
        end
      }, status: :ok
    else
      render json: { error: "Ticket not found" }, status: :not_found
    end
  end
end

def update_status
  @ticket = Ticket.find(params[:ticket_id])
  new_status = Status.find(params[:new_status_id])

  if can_update_status?(@ticket, new_status)
    @ticket.status = new_status
    if @ticket.save
      log_status_change(@ticket, new_status)
      render json: @ticket, status: :ok
    else
      render json: { errors: @ticket.errors }, status: :unprocessable_entity
    end
  else
    render json: { error: "Invalid status change" }, status: :bad_request
  end
end

private

def can_update_status?(ticket, new_status)
  return false if ticket.status == new_status

  case ticket.status.name
  when "New"
    [ "Open" ].include?(new_status.name)
  when "Open"
    [ "InProgress", "Resolved", "Cancelled" ].include?(new_status.name)
  when "InProgress"
    [ "Resolved", "Cancelled" ].include?(new_status.name)
  when "Resolved"
    [ "Closed", "Reserved" ].include?(new_status.name)
  when "Closed"
    [ "Available", "Sold" ].include?(new_status.name)
  when "Cancelled"
    false
  when "Reserved"
    [ "Sold" ].include?(new_status.name)
  when "Available"
    [ "Reserved", "Sold" ].include?(new_status.name)
  when "Sold"
    false
  else
    false
  end
end

def log_status_change(ticket, new_status)
  ticket.ticket_logs.create(status: new_status, timestamp: Time.now)
end

  skip_before_action :verify_authenticity_token, only: [ :create ]

  def create
    @event = Event.find(params[:event_id])

    if @event.tickets.count < @event.capacity
      @ticket = @event.tickets.create(expire_date: 30.days.from_now, serial_ticket: SecureRandom.hex(4).upcase)

      if @ticket.persisted?
        render json: @ticket, status: :created
      else
        render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
      end
    else
      # Return error if the event has reached its capacity
      render json: { errors: [ "Event is at full capacity" ] }, status: :unprocessable_entity
    end
  end
end
