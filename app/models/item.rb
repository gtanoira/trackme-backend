class Item < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :warehouse
  belongs_to :entity, foreign_key: :client_id
  belongs_to :order
end
