class Company < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :country
  belongs_to :holding
  has_many :entities
  has_many :users
  
  # Polymorphic association
  has_many :endpoints, as: :pointable
end
