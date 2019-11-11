class CreateCustomerOrders < ActiveRecord::Migration[5.2]
   def change
      create_table :customer_orders do |t|
         # General Data
         t.bigint   :company_id,      null: false
         t.bigint   :customer_id,     null: false
         t.integer  :order_no,        null: false
         t.datetime :order_date,      null: false, default: -> {'CURRENT_TIMESTAMP'}
         t.text     :observations,    limit: 4000
         t.string   :cust_ref,        comment: 'Customer Order ID'
         t.string   :order_type,      limit: 1, null: false, default: 'D', comment: '(P):pick-up by Co. / (D):delivery by Co. / (I):pick-up by client / (E)delivery by client'
         t.string   :order_status,    limit: 1, null: false, default: 'P', comment: '(P):pending / (C):confirmed / (F):finished / (A):cancelled'
         t.datetime :cancel_date,     comment: 'Date when the order was cancelled'
         t.string   :cancel_user,     comment: 'User ID who cancelled the order'
         t.string   :applicant_name,  comment: 'Customer person who is responsible for the order'
         t.string   :old_order_no,    comment: 'Order ID No. for the legacy system'
         t.string   :incoterm,        limit: 3, comment: 'Type of transaction: FOB, etc'
         t.string   :shipment_method, limit: 1, default: 'A', comment: 'Shipment method: (A):air / (B):boat / (G):ground'
         t.date     :eta,             comment: 'Estimated Time of Arrival'
         t.date     :delivery_date,   comment: 'Real Delivery Date'
         # FROM data (Shipper)
         t.string   :from_entity,     :null => false
         t.text     :from_address1,   limit: 4000
         t.text     :from_address2,   limit: 4000
         t.string   :from_city
         t.string   :from_zipcode    
         t.string   :from_state      
         t.string   :from_country_id, :limit => 3, :null => false
         t.string   :from_contact
         t.string   :from_email
         t.string   :from_tel
         # TO data (Consignee)
         t.string   :to_entity,       :null => false
         t.text     :to_address1,     limit: 4000
         t.text     :to_address2,     limit: 4000
         t.string   :to_city
         t.string   :to_zipcode
         t.string   :to_state
         t.string   :to_country_id,   :limit => 3, :null => false
         t.string   :to_contact
         t.string   :to_email
         t.string   :to_tel

         t.timestamps default: -> {'CURRENT_TIMESTAMP'}
      end

      # Add foreign keys
      add_foreign_key :customer_orders, :companies, column: :company_id
      add_foreign_key :customer_orders, :entities,  column: :customer_id
      add_foreign_key :customer_orders, :iso_countries, column: :from_country_id
      add_foreign_key :customer_orders, :iso_countries, column: :to_country_id

      # Add indexes
      add_index :customer_orders, [:company_id, :order_no], unique: true

   end
end
