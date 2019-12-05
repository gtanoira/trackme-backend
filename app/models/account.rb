class Account < ApplicationRecord
  # Referential Integrity: foreign key
  has_many :companies
  has_many :events
  has_many :tracking_milestones
  has_many :users
end
