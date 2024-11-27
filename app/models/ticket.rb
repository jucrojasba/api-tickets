class Ticket < ApplicationRecord
  belongs_to :status
  has_many :ticket_logs, dependent: :destroy

  validates :event_id, presence: true, numericality: { greater_than: 0 }, allow_nil: false
  validates :expire_date, presence: true
  validates :serial_ticket, uniqueness: true, presence: true

  #  scpoe for search of the controller
  scope :per_event, ->(event_id) { Ticket.where(event_id: event_id) }
  # Ex:- scope :active, -> {where(:active => true)}

  before_create :set_default_status

  private

  def set_default_status
    self.status_id ||= Status.find_by(id: 1)&.id || 1
    self.expire_date ||= 30.days.from_now
    self.serial_ticket ||= SecureRandom.hex(4).upcase
  end
end
