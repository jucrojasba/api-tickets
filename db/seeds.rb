# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
statuses = ([
  { id: 1, name: 'available' },
  { id: 2, name: 'reserved' },
  { id: 3, name: 'sold' },
  { id: 4, name: 'canceled' }
])

statuses.each do |status_data|
  Status.find_or_create_by!(id: status_data[:id]) do |status|
    status.name = status_data[:name]
  end
end


puts "Statuses creados: #{Status.count}"

# Crear Tickets específicos
puts "Creando Tickets..."

tickets = [
  { event_id: 1, expire_date: Date.today + 30, status_id: 1, serial_ticket: "TICKET001" },
  { event_id: 2, expire_date: Date.today + 45, status_id: 2, serial_ticket: "TICKET002" },
  { event_id: 3, expire_date: Date.today + 60, status_id: 3, serial_ticket: "TICKET003" },
  { event_id: 4, expire_date: Date.today + 15, status_id: 4, serial_ticket: "TICKET004" }
]


tickets.each do |ticket_data|
  Ticket.find_or_create_by!(serial_ticket: ticket_data[:serial_ticket]) do |ticket|
    ticket.event_id = ticket_data[:event_id]
    ticket.expire_date = ticket_data[:expire_date]
    ticket.status_id = ticket_data[:status_id]
  end
end


puts "Tickets creados."

# Crear Logs específicos para cada Ticket
puts "Creando Logs de Tickets..."

Ticket.all.each do |ticket|
  logs = [
    { ticket: ticket, status: 1 }, # Estado 1 (por ejemplo: available)
    { ticket: ticket, status: 2 }, # Estado 2 (por ejemplo: reserved)
    { ticket: ticket, status: 3 },  # Estado 3 (por ejemplo: sold)
    { ticket: ticket, status: 4 }
  ]
  logs.each do |log_data|
    TicketLog.find_or_create_by!(ticket_id: log_data[:ticket_id], state: log_data[:state])
  end
end

puts "Logs creados para los Tickets."
