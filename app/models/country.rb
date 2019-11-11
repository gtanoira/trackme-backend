class Country < ApplicationRecord
  # Referential Integrity: foreign key
  has_many :companies
  has_many :entities
  has_many :endpoints
end
