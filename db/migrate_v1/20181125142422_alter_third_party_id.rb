class AlterThirdPartyId < ActiveRecord::Migration[5.2]
  def change
    change_column :customer_orders, :third_party_id, :bigint, null: false
    # Add Foreign keys
    add_foreign_key :customer_orders, :entities, column: :third_party_id
  end
end
