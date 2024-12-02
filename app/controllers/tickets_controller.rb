
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
        error_message = case ticket.status.name
        when "available"
                          "Ticket status can only be updated to 'reserved' or 'sold'"
        when "reserved"
                          "Ticket status can only be updated to 'sold' or 'canceled'"
        when "sold"
                          "Ticket status cannot be updated from 'sold'"
        when "canceled"
                          "Ticket status cannot be updated from 'canceled'"
        else
                          "Invalid status change"
        end
        render json: { error: error_message }, status: :unprocessable_entity
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
        ticket_data = tickets.map { |ticket| { id: ticket.id, serial: ticket.serial_ticket } }

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
    quantity = params[:quantity].to_i

    # Verificar si el evento existe
    event_data = Ticket.get_data(event_id)
    if event_data.nil?
      return render json: { error: "Event not found" }, status: :not_found
    end

    max_tickets = event_data["tickets_quantity"].to_i

    # Consultar la cantidad actual de tickets generados para el evento
    current_ticket_count = Ticket.where(event_id: event_id).count

    # Calcular la cantidad de tickets a crear
    remaining_tickets = max_tickets - current_ticket_count

    if remaining_tickets <= 0
      return render json: { message: "No tickets available to create.", current_tickets: current_ticket_count }, status: :unprocessable_entity
    end

    tickets_to_create =  remaining_tickets

    created_tickets = []

    # Crear los tickets y logs asociados
    tickets_to_create.times do
      ticket = Ticket.create(event_id: event_id)
      if ticket.persisted?
        created_tickets << ticket
        TicketLog.create(ticket_id: ticket.id, status_id: ticket.status_id)
      end
    end

    # Responder con el detalle de la creación
    render json: {
      message: "Tickets created successfully",
      details: {
        previously_existing_tickets: current_ticket_count,
        tickets_created: created_tickets.size,
        total_tickets_now: current_ticket_count + created_tickets.size
      },
      tickets: created_tickets.map { |t| { id: t.id, event_id: t.event_id } }
    }, status: :created
  end
  def show
    @ticket = Ticket.find(params[:id])
    render json: @ticket
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ticket not found" }, status: :not_found
  end

  def index
    @tickets = Ticket.all
    render json: @tickets
  end
end
