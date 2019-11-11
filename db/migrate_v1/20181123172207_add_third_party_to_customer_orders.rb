class AddThirdPartyToCustomerOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :customer_orders, :third_party_id, :bigint, comment: 'Entity ID to invoice the customer_orders'

    reversible do |dir|
      dir.up do
        execute <<-SQL
          update customer_orders 
             set third_party_id = customer_id;
        SQL
      end
      dir.down do
      end
    end
    
  end
end
