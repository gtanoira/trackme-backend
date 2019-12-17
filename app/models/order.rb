class Order < ApplicationRecord
  # Referential Integrity: foreign key
  belongs_to :company
  belongs_to :entity, foreign_key: :client_id
  belongs_to :country, foreign_key: :from_country_id
  belongs_to :country, foreign_key: :to_country_id
  has_many :items
  has_many :order_events

  # ******************************************************************************
  # Get the last Client Order No. by a specific company id
  # 
  # Parameters;
  #   pcompany_id: company id to find the last order no.
  # Return: 
  #   last_order (number): last order No. for the company selected (returns 0 (cero) if there is no last order for the company)
  #
  def self.get_last_order_no(pcompany_id)
    @result = Order
      .select(:order_no)
      .order(order_no: :desc)
      .find_by_company_id(pcompany_id)

    last_order = (@result.blank?)? 0 : @result.order_no
    return last_order
  end

end
