class CreateOrderEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :order_events do |t|
      t.bigint   :event_id, null: false, comment: "Event"
      t.bigint   :user_id, null: false, comment: "User ID who creates the event"
      t.bigint   :order_id, null: false, comment: "Order who belongs to"
      t.string   :observations, limit: 1000
      t.string   :scope, comment: "If present, overrides the event scope default (values: private or public)"

      t.timestamps
    end

    # Add foreign keys
    add_foreign_key :order_events, :events
    add_foreign_key :order_events, :users
    add_foreign_key :order_events, :orders

  end
end
