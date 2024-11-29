FactoryBot.define do
  # Mensaje de depuración para confirmar que la factoría se carga
  puts "Cargando la factoría de Status"

  factory :status do
    name { 'available' } # Valor predeterminado

    # Define variantes (traits) para cada estado
    trait :available do
      name { 'available' }
    end

    trait :reserved do
      name { 'reserved' }
    end

    trait :sold do
      name { 'sold' }
    end

    trait :canceled do
      name { 'canceled' }
    end
  end
end
