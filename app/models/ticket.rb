class Ticket < ApplicationRecord
  belongs_to :status
  has_many :ticket_logs, dependent: :destroy

  validates :event_id, presence: true
  validates :expire_date, presence: true
end
