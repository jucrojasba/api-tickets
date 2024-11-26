class ChangeTicketsAddDefault < ActiveRecord::Migration[7.2]
  def change
    change_column_default(:tickets, :status_id, 1)
    change_column_default(:tickets, :expire_date, "DATE('now', '+30 days')")
  end
end
