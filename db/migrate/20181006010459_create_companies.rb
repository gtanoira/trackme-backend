class CreateCompanies < ActiveRecord::Migration[5.1]
   def change
      create_table :companies do |t|
         t.string :country_id, limit: 3, default: 'NNN', null: false, index: true
         t.string :name

         t.timestamps  default: -> {'CURRENT_TIMESTAMP'}
      end

      # Add company_id to users table
      add_column :users, :company_id, :bigint, comment: 'Company where it belongs'

      # Add Foreign keys
      # Companies
      add_foreign_key :companies, :countries
      # Users
      add_foreign_key :users, :companies
   
   end
end
