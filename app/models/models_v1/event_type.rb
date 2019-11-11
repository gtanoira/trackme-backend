class EventType < ApplicationRecord
  belongs_to :tracking_milestone
  has_many :order_events
end
