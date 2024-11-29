class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.integer :event_id, null: false
      t.date :expire_date, null: false,  default: -> { "CURRENT_DATE + interval '30 days'" }
      t.references :status, null: false, foreign_key: true
      t.integer :serial_ticket, null: true # deprecated

      t.timestamps
    end
  end
end
