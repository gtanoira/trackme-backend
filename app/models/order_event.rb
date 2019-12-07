class OrderEvent < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :order
  belongs_to :user
  belongs_to :event
end
