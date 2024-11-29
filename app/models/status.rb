class Status < ApplicationRecord
  has_many :tickets
  has_many :ticket_logs

  validates :name, presence: true, length: { maximum: 50 }

  def can_transition_to?(new_status)
    case name
    when "available"
      [ "reserved", "sold" ].include?(new_status.name)
    when "reserved"
      [ "sold", "canceled" ].include?(new_status.name)
    when "sold"
      false
    when "canceled"
      false
    else
      false
    end
  end
end
