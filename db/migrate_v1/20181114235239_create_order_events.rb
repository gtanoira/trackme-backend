class CreateOrderEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :order_events do |t|
      t.bigint   :event_type_id, null: false 
      t.bigint   :user_id, null: false, comment: "User ID who creates the event"
      t.string   :type, null: false, default: 'CustomerOrderEvent', comment: "Type of event: CustomerOrderEvent, WarehouseReceiptEvent or ShipmentEvent"
      t.bigint   :order_id, null: false, comment: 'Used with the field TYPE, determines the order it belongs to'
      t.datetime :event_datetime
      t.string   :observations, limit: 1000
      t.string   :event_scope, limit: 3, default: 'PRI', comment: "(PRI):private, only visible by the company / (PUB):visible by all, company and customer"

      t.timestamps
    end

    # Add foreign keys
    add_foreign_key :order_events, :event_types, column: :event_type_id
    add_foreign_key :order_events, :users,  column: :user_id

  end
end
