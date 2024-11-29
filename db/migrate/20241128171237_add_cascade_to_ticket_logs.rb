class AddCascadeToTicketLogs < ActiveRecord::Migration[7.2]
  def change
       # Eliminar la clave foránea existente
       remove_foreign_key :ticket_logs, :tickets

       # Agregar la nueva clave foránea con `on_delete: :cascade`
       add_foreign_key :ticket_logs, :tickets, on_delete: :cascade
  end
end
