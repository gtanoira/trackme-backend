class CreateEntities < ActiveRecord::Migration[5.2]
   def change
      create_table :entities do |t|
         t.string :name,        index: true, unique: true
         t.string :address1,    limit: 4000
         t.string :address2,    limit: 4000
         t.string :city
         t.string :zipcode
         t.string :state
         t.string :alias,       limit: 10, comment: ''
         t.string :entity_type, limit: 3,  null: false, default: 'CUS', comment: "Entity type: (CUS)customer, (PRO)provider, (CAR)cargo"
         t.string :country_id,  limit: 3,  default: 'NNN', null: false
         t.bigint :company_id,  comment:  'Use for Migration purpose only, to set all the CustomerOrders company_id field'
      
         t.timestamps default: -> {'CURRENT_TIMESTAMP'}
      end

      # Add foreign keys
      add_foreign_key :entities, :iso_countries, column: :country_id
   end
end
