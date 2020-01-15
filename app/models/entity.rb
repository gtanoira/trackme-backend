class Entity < ApplicationRecord
  # Foreign keys
  belongs_to :country
  belongs_to :company
  has_many :items
  has_many :item_models
  
  # Polymorphic associations
  has_many :endpoints, as: :pointable

end
