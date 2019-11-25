class Entity < ApplicationRecord
  # Foreign keys
  belongs_to :country
  
  # Polymorphic associations
  has_many :endpoints, as: :pointable

end
