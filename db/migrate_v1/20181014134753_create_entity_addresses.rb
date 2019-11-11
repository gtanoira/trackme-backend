class CreateEntityAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :entity_addresses do |t|
      t.string   :country_id, limit: 3, null: false, default: 'NNN'
      t.string   :entity_area, null: false
      t.string   :address1,   limit: 4000
      t.string   :address2,   limit: 4000
      t.string   :city
      t.string   :zipcode    
      t.string   :state      
      t.string   :contact
      t.string   :email
      t.string   :tel
      
      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :entity_addresses, :countries

    # Add indexes
    add_index :entity_addresses, :entity, unique: true

  end
end
