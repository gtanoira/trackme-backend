class AlterTypeOnInternalOrder < ActiveRecord::Migration[5.2]
  def change
    change_column :internal_orders, :type, :string, default: 'WarehouseReceipt', comment: "Type of order: WarehouseReceipt or Shipment" 
  end
end
