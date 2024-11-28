class TicketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :update_status ]

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
            changed_at: log.created_at,
            event_id: @ticket.event_id
          }
        end
      }, status: :ok
    else
      render json: { error: "Ticket not found" }, status: :not_found
    end
  end


  # PATCH/PUT /tickets/:ticket_id/update_status
  def update_status
    ticket = Ticket.find(params[:ticket_id])
    new_status = Status.find(params[:new_status_id])

    begin
      if ticket.status.can_transition_to?(new_status)
        ticket.status = new_status
        ticket.save!

        ticket_logs_controller = TicketLogsController.new
        ticket_logs_controller.create_log(ticket, new_status)

        render json: ticket, status: :ok
      else
        render json: { error: "Invalid status change" }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def summary
    event_id = params[:event_id]

    tickets = Ticket.per_event(event_id).joins(:status)

    if tickets.exists?
      render json: {
        event_id: event_id,
        available_tickets: tickets.where(statuses: { name: "available" }).count,
        reserved_tickets: tickets.where(statuses: { name: "reserved" }).count,
        sold_tickets: tickets.where(statuses: { name: "sold" }).count,
        canceled_tickets: tickets.where(statuses: { name: "canceled" }).count,
        total_tickets: tickets.count
      }, status: :ok
    else
      render json: { error: "Not event" }, status: :not_found
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Event not found" }, status: :not_found
  end

  def create
    event_id = params[:event_id]
    @ticket_data = Ticket.get_data(event_id)

    if @ticket_data.nil?
      render json: { error: "Event not found" }, status: :not_found
      return
    end

    ticket_quantity = @ticket_data["data"]["tickets_quantity"].to_i
    event_capacity = @ticket_data["data"]["capacity"].to_i

    if ticket_quantity > event_capacity
      render json: { error: "Capacity exceeded" }, status: :unprocessable_entity
      return
    end

    ticket_quantity.times do
      ticket = Ticket.new(event_id: event_id)

      if ticket.save
        # Optionally, you can log each created ticket or any other logic you want
      else
        render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end

    render json: { message: "#{ticket_quantity} tickets created successfully", event_id: event_id }, status: :created
  end
end
