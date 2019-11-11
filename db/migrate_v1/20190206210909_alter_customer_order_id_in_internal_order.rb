class AlterCustomerOrderIdInInternalOrder < ActiveRecord::Migration[5.2]
  def change
    change_column :internal_orders, :customer_order_id, :bigint, null: true
  end
end
