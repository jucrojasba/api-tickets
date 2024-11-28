class Ticket < ApplicationRecord
  belongs_to :status
  has_many :ticket_logs, dependent: :delete_all


  validates :event_id, presence: true, numericality: { greater_than: 0 }, allow_nil: false
  validates :expire_date, presence: true
  validates :serial_ticket, uniqueness: true, presence: true

  #  scpoe for search of the controller
  scope :per_event, ->(event_id) { Ticket.where(event_id: event_id) }
  # Ex:- scope :active, -> {where(:active => true)}


  before_create :set_default_status

  def self.get_data(event_id)
    @data ||= NetService.get_resource("api/v1/events/#{event_id}")
  end
  private
  def set_default_status
    self.status_id ||= Status.find_by(id: 1)&.id || 1
    self.expire_date ||= 30.days.from_now
    self.serial_ticket ||= set_serial_ticket
  end

  def set_serial_ticket
    name_event = @data.event.name
    id_event = @data.event.id

    serial = name_event.split.map { | word | word[0] }.join

    serial += id_event.to_s
    serial
  end
end
