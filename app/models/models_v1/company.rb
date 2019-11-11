class Company < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :country
end
