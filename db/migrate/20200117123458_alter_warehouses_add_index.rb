class AlterWarehousesAddIndex < ActiveRecord::Migration[5.2]
  def change
    # Add indexes
    add_index :warehouses, [:alias], unique: true
  end
end
