class CreateWarehouses < ActiveRecord::Migration[5.2]
  def change
    create_table :warehouses do |t|
      t.string  :name, null: false, comment: "Name of the warehouse"
      t.bigint  :company_id, null: false, comment: "Company where it belongs"
    end

    # Add foreign keys
    add_foreign_key :warehouses, :companies
  end
end
