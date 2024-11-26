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
