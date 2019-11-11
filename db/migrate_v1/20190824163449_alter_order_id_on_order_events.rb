class AlterOrderIdOnOrderEvents < ActiveRecord::Migration[5.2]
  def change
    rename_column :order_events, :order_id, :customer_order_id
  end
end
