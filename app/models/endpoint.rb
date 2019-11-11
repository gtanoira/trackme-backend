class Endpoint < ApplicationRecord
  #self.abstract_class = true

  # Referential Integrity
  belongs_to :country

  # Polymorphic
  belongs_to :pointable, polymorphic: true
end
