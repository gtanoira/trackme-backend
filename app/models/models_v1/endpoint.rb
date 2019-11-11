class Endpoint < ApplicationRecord
  self.abstract_class = true
  belongs_to :country, class_name: 'IsoCountry'
end
