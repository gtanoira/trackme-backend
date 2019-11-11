class CreateEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :endpoints do |t|
      # Polymorphic definition
      t.bigint :pointable_id, null: false, comment: 'polymorphic ID'
      t.string :pointable_type, null: false, comment: "polymorphic TYPE: CompanyAddress, EntityAddress, WarehouseAddress"
      
      t.string :name
      t.string :address1,    limit: 4000
      t.string :address2,    limit: 4000
      t.string :city
      t.string :zipcode
      t.string :state
      t.string :country_id,  limit: 3,  default: 'NNN', null: false
      t.string :contact
      t.string :email
      t.string :tel

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :endpoints, :countries

    # Add indexes
    add_index :endpoints, [:pointable_type, :pointable_id, :name], unique: true
  end
end
