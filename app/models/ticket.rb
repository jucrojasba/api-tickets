class Ticket < ApplicationRecord
  belongs_to :status
  has_many :ticket_logs

  validates :event_id, presence: true, numericality: { greater_than: 0 }, allow_nil: false
  validates :expire_date, presence: true
  # TODO(optional) add scpoe for search of the controller
end
