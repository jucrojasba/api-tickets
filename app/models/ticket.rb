class Ticket < ApplicationRecord
  belongs_to :status
  has_many :ticket_logs, dependent: :destroy

  validates :event_id, presence: true, numericality: { greater_than: 0 }, allow_nil: false
  validates :expire_date, presence: true
  # TODO(optional) add scpoe for search of the controller
  scope :per_event, ->(event_id) { Ticket.where(event_id: event_id) }
  # Ex:- scope :active, -> {where(:active => true)}
end
