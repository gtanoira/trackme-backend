class AddPiecesToCustomerOrders < ActiveRecord::Migration[5.2]
  def change
      add_column :customer_orders, :pieces, :integer
  end
end
