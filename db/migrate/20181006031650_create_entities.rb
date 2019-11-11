class CreateEntities < ActiveRecord::Migration[5.2]
   def change
      create_table :entities do |t|
         t.string :country_id,  limit: 3,  default: 'NNN', null: false
         t.bigint :company_id,  null: false, comment:  'Company where it belong'
         t.string :type, null: false, default: 'Client', comment: "STI table, entity type: Client, Supplier, Carrier"
         t.string :name, index: true, unique: true
         t.string :alias, index: true, unique: true, limit: 10, comment: 'Short for entity name. Used in QR and stamps'
      
         t.timestamps default: -> {'CURRENT_TIMESTAMP'}
      end

      # Add foreign keys
      add_foreign_key :entities, :countries
      add_foreign_key :entities, :companies
   end
end
