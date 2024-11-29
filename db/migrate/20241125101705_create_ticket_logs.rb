class CreateTicketLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :ticket_logs do |t|
      t.references :ticket, null: false, foreign_key: true
      t.integer :state, null: false

      t.timestamps
    end
  end
end
