class AddTicketLogToStatus < ActiveRecord::Migration[7.2]
  def change
    add_reference :ticket_logs, :status, null: false, foreign_key: true
  end
end
