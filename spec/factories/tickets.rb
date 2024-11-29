puts "Cargando la factoría de Ticket"
FactoryBot.define do
  factory :ticket do
    event_id { 1 } # Valor por defecto
    expire_date { Time.now + 1.day } # Fecha de vencimiento
    serial_ticket { SecureRandom.hex(8) } # Identificador único
    association :status # Relación con el modelo Status
  end
end
