class CreateItemModels < ActiveRecord::Migration[5.2]
  def change
    create_table :item_models do |t|
      t.bigint   :client_id, null: false, comment: "Client owner of the item"
      t.string   :model
      t.string   :unit_length, null: false, default: 'cm', comment: 'Unit of measure for distance (enum)'
      t.decimal  :width,   precision: 9, scale: 2
      t.decimal  :height,  precision: 9, scale: 2
      t.decimal  :length,  precision: 9, scale: 2

      t.string   :unit_weight, null: false, default: 'kg', comment: 'Unit of measure for weight (enum)'
      t.decimal  :weight,  precision: 9, scale: 2

      t.string  :unit_volumetric, null: false, default: 'kgV', comment: 'Unit of measure for volumetric weight (enum)'
      t.decimal  :volume_weight,   precision: 9, scale: 2
    end

    # Add foreign keys
    add_foreign_key :item_models, :entities,  column: :client_id

    # Add indexes
    add_index :item_models, [:client_id, :model], unique: true

    # ENUMS fields integrity
    reversible do |dir|
      dir.up do
        # Populate the ENUM fields
        execute <<-SQL
          ALTER TABLE items MODIFY `unit_length` enum('cm', 'inch') NOT NULL DEFAULT 'cm' COMMENT 'Unit of measure for distance (enum)',
                            MODIFY `unit_weight` enum('kg', 'lb') NOT NULL DEFAULT 'kg' COMMENT 'Unit of measure for weight (enum)',
                            MODIFY `unit_volumetric` enum('kgV', 'lbV') NOT NULL DEFAULT 'kgV' COMMENT 'Unit of measure for volumetric weight (enum)';
        SQL
      end
      dir.down do
        change_column :item_models, :unit_length, :string, comment: 'Unit of measure for distance (enum)'
        change_column :item_models, :unit_weight, :string, comment: 'Unit of measure for weight (enum)'
        change_column :item_models, :unit_volumetric, :string, comment: 'Unit of measure for volumetric weight (enum)'
      end
    end

  end
end
