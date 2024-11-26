require 'faker'

# Populate statuses
[
  'available',
  'reserved',
  'sold',
  'canceled'
].each do |state|
  Status.find_or_create_by!(name: state)
end

# Fetch all statuses
statuses = Status.all

# Generate 1000 unique tickets and ticket logs
1000.times do
  serial_ticket = SecureRandom.hex(8)
  while Ticket.exists?(serial_ticket: serial_ticket)
    serial_ticket = SecureRandom.hex(8)
  end

  ticket = Ticket.create!(
    event_id: Faker::Number.between(from: 1, to: 20), # Fixed range of event IDs
    expire_date: Faker::Date.forward(days: 365),      # Random future date
    status_id: statuses.sample.id,                   # Random status
    serial_ticket: serial_ticket,                    # Unique serial
    created_at: Time.now,
    updated_at: Time.now
  )

  TicketLog.create!(
    ticket_id: ticket.id,
    status_id: ticket.status_id,
    created_at: Time.now,
    updated_at: Time.now
  )
end

puts "Seed completed: 1000 tickets and their logs have been created."
