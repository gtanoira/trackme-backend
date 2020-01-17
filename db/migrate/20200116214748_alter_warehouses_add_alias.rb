class AlterWarehousesAddAlias < ActiveRecord::Migration[5.2]
  def change
    add_column :warehouses, :alias, :string, null: false, comment: 'Use as prefix for all itemId items in the warehouse. This field can never be modified, once set'
  end
end
