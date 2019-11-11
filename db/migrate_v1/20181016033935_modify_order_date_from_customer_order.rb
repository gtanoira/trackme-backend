class ModifyOrderDateFromCustomerOrder < ActiveRecord::Migration[5.2]
  def change
    change_column :customer_orders, :order_date, :date, null: false
  end
end
