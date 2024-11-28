FactoryBot.define do
  factory :ticket do
    event_id { 1 }
    serial_ticket { "TICKET-#{rand(1000..9999)}" }
    expire_date { 30.days.from_now }
    status { Status.first || create(:status) }
  end
end
