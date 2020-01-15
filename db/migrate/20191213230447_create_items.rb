class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string   :item_id, null: false,  comment: 'This is the ID that goes in the sticker attached to the box'
      t.bigint   :warehouse_id, null: false, comment: "Last warehouse where the item was stored"
      t.bigint   :client_id, null: false, comment: "Client owner of the item"
      t.bigint   :order_id, null: false, comment: "Order (WR or SH) where it belongs"
      t.string   :item_type, null: false, default: 'box', comment: 'Determines the type of content of the Item (enum)'
      t.string   :status, null: false, default: 'onhand', comment: 'Specifies the actual status of the item in the process of delivering (enum)'
      t.integer  :quantity, default: 0, comment: "Stock quantity"
      t.string   :deleted_by, comment: "Person who deletes the item from the system"
      t.datetime :deleted_datetime, comment: 'Date-Time when the item was deleted'
      t.string   :deleted_cause, comment: "Deletes means the item was canceled or out of the system by some reason"
      t.string   :image_filename, comment: "Name of the image file, if exists"
      t.string   :content_filename, comment: "Name of the DOC file containing the content of the item, if exists"

      t.string   :manufacter
      t.string   :model
      t.string   :part_number
      t.string   :serial_number
      t.string   :ua_number, comments: 'Used in DECODERS item types'
      t.string   :condition, null: false, default: 'original', comment: 'Item type: original, used, etc. (enum)'
      t.string   :description, limit: 1000
      
      t.string   :unit_length, null: false, default: 'cm', comment: 'Unit of measure for distance (enum)'
      t.decimal  :width,   precision: 9, scale: 2
      t.decimal  :height,  precision: 9, scale: 2
      t.decimal  :length,  precision: 9, scale: 2

      t.string   :unit_weight, null: false, default: 'kg', comment: 'Unit of measure for weight (enum)'
      t.decimal  :weight,  precision: 9, scale: 2

      t.string  :unit_volumetric, null: false, default: 'kgV', comment: 'Unit of measure for volumetric weight (enum)'
      t.decimal  :volume_weight,   precision: 9, scale: 2

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :items, :warehouses
    add_foreign_key :items, :entities,  column: :client_id
    add_foreign_key :items, :orders

    # Add indexes
    add_index :items, [:item_id, :warehouse_id], unique: true

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE items MODIFY `condition`   enum('original', 'used', 'failed', 'repaired') NOT NULL DEFAULT 'original' COMMENT 'Item type: original(new), used, etc. (enum)',
                            MODIFY `item_type`   enum('box', 'deco', 'pallet', 'generic') NOT NULL DEFAULT 'box' COMMENT 'Determines the type of content of the Item (enum)',
                            MODIFY `status`      enum('onhand', 'intransit', 'delivered', 'deleted') NOT NULL DEFAULT 'onhand' COMMENT 'Specifies the actual status of the item in the process of delivering (enum)',
                            MODIFY `unit_length` enum('cm', 'inch') NOT NULL DEFAULT 'cm' COMMENT 'Unit of measure for distance (enum)',
                            MODIFY `unit_weight` enum('kg', 'lb') NOT NULL DEFAULT 'kg' COMMENT 'Unit of measure for weight (enum)',
                            MODIFY `unit_volumetric` enum('kgV', 'lbV') NOT NULL DEFAULT 'kgV' COMMENT 'Unit of measure for volumetric weight (enum)';
        SQL
      end
      dir.down do
        change_column :items, :condition,   :string, comment: 'Item type: original, used, etc. (enum)'
        change_column :items, :item_type,   :string, comment: 'Determines the type of content of the Item (enum)'
        change_column :items, :status,      :string, comment: 'Specifies the actual status of the item in the process of delivering (enum)'
        change_column :items, :unit_length, :string, comment: 'Unit of measure for distance (enum)'
        change_column :items, :unit_weight, :string, comment: 'Unit of measure for weight (enum)'
        change_column :items, :unit_volumetric, :string, comment: 'Unit of measure for volumetric weight (enum)'
      end
    end


  end
end
