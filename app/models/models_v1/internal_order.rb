class InternalOrder < ApplicationRecord

  # Referential Integrity: foreign key
  belongs_to :company, class_name: 'Company',    foreign_key: :company_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :fromCountry_id
  belongs_to :country, class_name: 'IsoCountry', foreign_key: :toCountry_id
  has_many :items
end
