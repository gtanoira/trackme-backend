class Holding < ApplicationRecord
  # Referential Integrity: foreign key
  has_many :companies
end
