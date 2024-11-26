class TicketLog < ApplicationRecord
  belongs_to :ticket
  belongs_to :status

  validates :state, presence: true
end
