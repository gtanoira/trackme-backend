class AlterOrdersStatus < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :status, :string, null: false, default: 'loading', :after => :type, comment: 'Status for the order (enum)'
    remove_column :orders, :order_status, :string

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE orders MODIFY `status` enum('loading', 'inTransit', 'delivered') NOT NULL DEFAULT 'loading' COMMENT 'Status for the order (enum)';
        SQL
      end
    end
  end
end
