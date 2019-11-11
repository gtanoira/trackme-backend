class AddCustomerOrderFkToInternalOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :internal_orders, :customer_order_id, :bigint, null: false, comment: 'Customer Order ID which this order belongs to'
    add_column :internal_orders, :type, :string, null: false, default: 'WarehouseReceiptOrder', comment: "Type of event: WarehouseReceiptOrder or ShipmentOrder"

    # Add foreign keys
    add_foreign_key :internal_orders, :customer_orders, column: :customer_order_id
  end

end
