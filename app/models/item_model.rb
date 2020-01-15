class ItemModel < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :entity, foreign_key: :client_id
end
