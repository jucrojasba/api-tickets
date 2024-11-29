# spec/factories/ticket_logs.rb
FactoryBot.define do
  factory :ticket_log do
    association :ticket # Relación con Ticket
    status_id { ticket.status_id } # Usa el mismo status_id del ticket
  end
end
