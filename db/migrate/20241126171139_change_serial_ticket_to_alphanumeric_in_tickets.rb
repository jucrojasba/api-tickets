class ChangeSerialTicketToAlphanumericInTickets < ActiveRecord::Migration[7.2]
  def up
    # Cambiar el tipo de columna a string
    change_column :tickets, :serial_ticket, :string

    # Opcional: Agregar un índice único para asegurar unicidad si aún no existe
    add_index :tickets, :serial_ticket, unique: true
  end

  def down
    # Revertir el cambio al tipo original (integer)
    remove_index :tickets, :serial_ticket if index_exists?(:tickets, :serial_ticket)
    change_column :tickets, :serial_ticket, :integer
  end
end
