class Account < ApplicationRecord
  # Referential Integrity: foreign key
  has_many :companies
  has_many :users
  has_many :events
end
