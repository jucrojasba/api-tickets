class TicketLog < ApplicationRecord
  belongs_to :ticket

  validates :state, presence: true
end
