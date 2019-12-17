class Entity < ApplicationRecord
  # Foreign keys
  belongs_to :country
  belongs_to :company
  
  # Polymorphic associations
  has_many :endpoints, as: :pointable
  has_many :items

end
