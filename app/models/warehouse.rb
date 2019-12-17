class Warehouse < ApplicationRecord
  # Foreign keys
  belongs_to :company
  has_many :items
end
