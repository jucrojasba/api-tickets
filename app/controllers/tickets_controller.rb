
require_relative "../../app/controllers/tickets_controller"

class TicketsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :update_status, :create ]

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

  # GET events/:event_id/tickets/:quantity
  def reserve_tickets
    event_id = params[:event_id]
    quantity = params[:quantity]
    tickets = Ticket.giving_ticket_avaliables(event_id, quantity, "available")

    if quantity.to_i <= tickets.count()

      if tickets.exists?
        ticket_data = tickets.map { |ticket| { id: ticket.id, serial: ticket.serial_ticket} }

        render json: {
          event_id: event_id,
          tickets: ticket_data
        }, status: :ok
      end
    else
      render json: { error: "not enough tickets" }, status: :range_not_satisfiable

    end
  end


  def summary
    event_id = params[:event_id]

    tickets = Ticket.per_event(event_id).joins(:status)

      # Depurador para verificar los tickets encontrados
      puts tickets.inspect
      puts tickets.where(statuses: { name: "available" }).count

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

    tickets_created = []
    ticket_quantity.times do
      ticket = Ticket.new(
        event_id: event_id,
        event_data: @ticket_data["data"]
      )
      if ticket.save
        tickets_created << ticket
      else
        render json: { errors: ticket.errors.full_messages }, status: :unprocessable_entity
        return
      end
    end

    render json: { message: "#{tickets_created.size} tickets created successfully", tickets: tickets_created }, status: :created
  end
end
