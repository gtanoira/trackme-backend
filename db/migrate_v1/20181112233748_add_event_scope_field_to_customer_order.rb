class AddEventScopeFieldToCustomerOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :customer_orders, :events_scope, :string, limit: 1, default: 'G', comment: 'For tracking purpose. Where to show only (G)lobal or (P)artial events to clients'
  end
end
