class TicketLogsController < ApplicationController
  def create_log(ticket, new_status)
    TicketLog.create!(
      ticket: ticket,
      status: new_status,
      created_at: Time.current,
      updated_at: Time.current
    )
  end
end
