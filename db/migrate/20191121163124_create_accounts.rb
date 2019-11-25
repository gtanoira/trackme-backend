class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      
      t.timestamps  default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add company_id to users table
    add_column :users, :account_id, :bigint, comment: 'Account associated to the user'
    add_column :companies, :account_id, :bigint, comment: 'Account associated to the company'

    # Add Foreign keys
    # Companies
    add_foreign_key :companies, :accounts
    # Users
    add_foreign_key :users, :accounts

  end
end
