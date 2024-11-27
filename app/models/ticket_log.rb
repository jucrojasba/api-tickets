class TicketLog < ApplicationRecord
  belongs_to :ticket
  belongs_to :status

  validates :status_id, presence: true
end
