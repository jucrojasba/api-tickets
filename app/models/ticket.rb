class Ticket < ApplicationRecord
  belongs_to :event
  belongs_to :status
  has_many :ticket_logs

  validates :event_id, presence: true
  validates :expire_date, presence: true
  validates :serial_ticket, uniqueness: true, presence: true

  before_create :set_default_status

  private

  def set_default_status
    self.status_id ||= Status.find_by(id: 1)&.id || 1
    self.expire_date ||= 30.days.from_now
    self.serial_ticket ||= SecureRandom.hex(4).upcase
  end
end
