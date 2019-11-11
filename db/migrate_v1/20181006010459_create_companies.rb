class CreateCompanies < ActiveRecord::Migration[5.1]
   def change
      create_table :companies do |t|
         t.string :name
         t.string :address1,   limit: 4000
         t.string :address2,   limit: 4000
         t.string :city
         t.string :zipcode
         t.string :country_id, limit: 3, default: 'NNN', null: false, index: true

         t.timestamps  default: -> {'CURRENT_TIMESTAMP'}
      end

      # Add Foreign keys
      add_foreign_key :companies, :countries, column: :country_id
   
   end
end
