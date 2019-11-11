class CreateTableItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.bigint   :company_id,   null: false
      t.bigint   :customer_id,  null: false
      t.string   :item_id,      null: false,  comment: 'This is the ID that goes in the sticker attached to the box'
      t.bigint   :internal_order_id, null: false, comment: 'Internal order ID where this item belongs to'
      t.string   :item_type,    null: false, default: 'Box', comment: 'Determines the type of content of the Item (enum)'
      t.string   :status,       null: false, default: 'OnHand', comment: 'Specifies the actual status of the item in the process of delivering (enum)'
      t.string   :deleted_by
      t.string   :deleted_cause

      t.string   :manufacter
      t.string   :model
      t.string   :part_number
      t.string   :serial_number
      t.string   :ua_number, comments: 'Used in DECODERS item types'
      t.string   :condition,   null: false, default: 'Original', comment: 'Item type: new, used, etc. (enum)'    
      t.text     :contents, :limit => 4294967295

      t.string   :unit_length, null: false, default: 'cm', comment: 'Unit of measure for distance (enum)'
      t.decimal  :width,   precision: 9, scale: 2
      t.decimal  :height,  precision: 9, scale: 2
      t.decimal  :length,  precision: 9, scale: 2

      t.string   :unit_weight, null: false, default: 'kg', comment: 'Unit of measure for weight (enum)'
      t.decimal  :weight,  precision: 9, scale: 2

      t.string  :unit_volume, null: false, default: 'm3', comment: 'Unit of measure for volume weight (enum)'
      t.decimal  :volume_weight,   precision: 9, scale: 2

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :items, :companies, column: :company_id
    add_foreign_key :items, :entities,  column: :customer_id
    add_foreign_key :items, :internal_orders, column: :internal_order_id

    # Add indexes
    add_index :items, [:item_id, :company_id], unique: true

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE items MODIFY `condition`   enum('Original', 'Used', 'Failed', 'Repaired') NOT NULL DEFAULT 'Original' COMMENT 'Item type: new, used, etc. (enum)',
                            MODIFY `item_type`   enum('Box', 'Deco') NOT NULL DEFAULT 'Box' COMMENT 'Determines the type of content of the Item (enum)',
                            MODIFY `status`      enum('OnHand', 'InTransit', 'Delivered', 'Deleted') NOT NULL DEFAULT 'OnHand' COMMENT 'Specifies the actual status of the item in the process of delivering (enum)',
                            MODIFY `unit_length` enum('cm', 'inch') NOT NULL DEFAULT 'cm' COMMENT 'Unit of measure for distance (enum)',
                            MODIFY `unit_volume` enum('m3', 'kg3') NOT NULL DEFAULT 'm3' COMMENT 'Unit of measure for volume weight (enum)',
                            MODIFY `unit_weight` enum('kg', 'pounds') NOT NULL DEFAULT 'kg' COMMENT 'Unit of measure for weight (enum)';
        SQL
      end
      dir.down do
        change_column :items, :condition,   :string, comment: 'Item type: original, used, etc. (enum)'
        change_column :items, :item_type,   :string, comment: 'Determines the type of content of the Item (enum)'
        change_column :items, :status,      :string, comment: 'Specifies the actual status of the item in the process of delivering (enum)'
        change_column :items, :unit_length, :string, comment: 'Unit of measure for distance (enum)'
        change_column :items, :unit_volume, :string, comment: 'Unit of measure for volume weight (enum)'
        change_column :items, :unit_weight, :string, comment: 'Unit of measure for weight (enum)'
      end
    end
  end
end
