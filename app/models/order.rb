class Order < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :company
  belongs_to :entity, foreign_key: :client_id
  belongs_to :country, foreign_key: :from_country_id
  belongs_to :country, foreign_key: :to_country_id
  has_many :order_events

end
