class TicketsController < ApplicationController
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
