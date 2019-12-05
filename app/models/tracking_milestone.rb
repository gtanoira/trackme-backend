class TrackingMilestone < ApplicationRecord
  # Foreign keys
  belongs_to :account
  has_many :events
end
