class Ticket < ApplicationRecord
  belongs_to :status

  has_many :ticket_logs, dependent: :destroy


  before_validation :set_default_status
  validates :event_id, presence: true, numericality: { greater_than: 0 }, allow_nil: false
  validates :expire_date, presence: true
  validates :serial_ticket, uniqueness: true, presence: true


  #  scope for search of the controller
  scope :per_event, ->(event_id) { Ticket.where(event_id: event_id) }
  # Ex:- scope :active, -> {where(:active => true)}



  def self.get_data(event_id)
    NetService.get_resource("events/#{event_id}.json")
  end

  private

  def set_default_status
    self.expire_date = 30.days.from_now if self.expire_date.nil?
    self.serial_ticket ||= set_serial_ticket
  end

  def set_serial_ticket
    event_data = NetService.get_resource("events/#{self.event_id}.json")

    name_event = event_data["name"]
    id_event = event_data["id"]
    serial = name_event.split.map { | word | word[0] }.join

    serial  += "-" +  id_event.to_s + "-" +  SecureRandom.hex(4)
    serial
  end
end
