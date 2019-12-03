class TrackingMilestone < ApplicationRecord
  # Foreign keys
  has_many :events
end
