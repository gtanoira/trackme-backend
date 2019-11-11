class Country < ApplicationRecord
  # Referential Integrity: foreign key
  has_many :companies
  has_many :customer_orders
  has_many :endpoints
  has_many :entities
  has_many :entity_addresses
end
