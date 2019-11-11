class CreateEndpoints < ActiveRecord::Migration[5.2]
  def change
    create_table :endpoints do |t|
      t.string :type, comment: "Type of endpoint: Company, Entity, Order, Warehouse"
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
    end

    # Add foreign keys
    add_foreign_key :endpoints, :iso_countries, column: :country_id

    # Add indexes
    add_index :endpoints, [:type, :name], unique: true

  end
end
