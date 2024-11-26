# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Status.create([
  {  name: 'available' },
  {  name: 'reserved' },
  {  name: 'sold' },
  {  name: 'canceled' }
])
Event.create([
  { id: 1, name: 'event1', capacity: 100 },
  { id: 2, name: 'event2', capacity: 90 },
  { id: 3, name: 'event3', capacity: 80 },
  { id: 4, name: 'event4', capacity: 70 }
])
