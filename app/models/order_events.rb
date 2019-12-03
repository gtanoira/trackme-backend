class OrderEvent < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :orders
  belongs_to :users
  belongs_to :events
end
