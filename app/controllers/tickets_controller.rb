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
