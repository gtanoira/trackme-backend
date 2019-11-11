class OrderEvent < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :event_type
  belongs_to :user
end
