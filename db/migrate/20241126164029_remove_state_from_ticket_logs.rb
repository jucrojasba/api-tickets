class RemoveStateFromTicketLogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :ticket_logs, :state, :integer
  end
end
