class Status < ApplicationRecord
  has_many :tickets
  has_many :ticket_logs

  validates :name, presence: true, length: { maximum: 50 }
end
