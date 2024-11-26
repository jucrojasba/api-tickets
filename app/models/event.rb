class Event < ApplicationRecord
  has_many :tickets
  validates :name, presence: true, length: { minimum: 5, maximum: 50 }
  validates :capacity, presence: true


  validate :ticket_capacity_not_exceeded, on: :create

  private
  def ticket_capacity_not_exceeded
    if tickets.count >= capacity
      errors.add(:capacity, "tickets are already full")
      false
    end
  end
end
