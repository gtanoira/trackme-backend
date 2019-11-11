class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      # Foreign-keys
      t.bigint   :company_id, null: false
      t.bigint   :client_id, null: false
      t.integer  :order_no, null: false
      t.string   :type, null: false, default: 'WarehouseReceipt', comment: 'STI table, values: WarehouseReceipt, Shipment'
      # Order data
      t.string   :applicant_name, comment: 'Client contact who is responsible for the order'
      t.datetime :cancel_datetime, comment: 'Date-Time when the order was cancelled'
      t.string   :cancel_user, comment: 'User ID who cancelled the order'
      t.string   :client_ref, comment: 'Client Order Reference'
      t.datetime :delivery_datetime, comment: 'Real Delivery Date-Time'
      t.date     :eta, comment: 'Estimated Time of Arrival'
      t.string   :incoterm, limit: 3, comment: 'Type of transaction: FOB, etc'
      t.string   :legacy_order_no, comment: 'Order ID in the legacy system'
      t.text     :observations, limit: 4000
      t.datetime :order_datetime, null: false, default: -> {'CURRENT_TIMESTAMP'}, comment: 'Date-Time when the order was place into the system'
      t.string   :order_status, limit: 1, null: false, default: 'P', comment: '(P):pending / (C):confirmed / (F):finished / (A):cancelled'
      t.string   :order_type, limit: 1, null: false, default: 'D', comment: '(P):pick-up by us / (D):delivery by us / (I):pick-up by client / (E)delivery by client'
      t.integer  :pieces, comment: 'No. of pieces within the order'
      t.string   :shipment_method, limit: 1, null: false, default: 'A', comment: 'Shipment method: (A):air / (B):boat / (G):ground'
      t.bigint   :third_party_id, null: false, comment: 'Client to invoice the order'
      # FROM data (Shipper)
      t.string   :from_entity, comment: 'Name of the entity'
      t.text     :from_address1, limit: 4000
      t.text     :from_address2, limit: 4000
      t.string   :from_city
      t.string   :from_zipcode    
      t.string   :from_state      
      t.string   :from_country_id, limit: 3, null: false, default: 'NNN'
      t.string   :from_contact
      t.string   :from_email
      t.string   :from_tel
      # TO data (Consignee)
      t.string   :to_entity, comment: 'Name of the entity'
      t.text     :to_address1, limit: 4000
      t.text     :to_address2, limit: 4000
      t.string   :to_city
      t.string   :to_zipcode
      t.string   :to_state
      t.string   :to_country_id, limit: 3, null: false, default: 'NNN'
      t.string   :to_contact
      t.string   :to_email
      t.string   :to_tel
      # CARRIER
      t.string   :ground_entity, comment: 'Name of the entity'
      t.string   :ground_booking_no
      t.string   :ground_departure_city
      t.date     :ground_departure_date
      t.string   :ground_arrival_city
      t.date     :ground_arrival_date

      t.string   :air_entity, comment: 'Name of the entity'
      t.string   :air_waybill_no
      t.string   :air_departure_city
      t.date     :air_departure_date
      t.string   :air_arrival_city
      t.date     :air_arrival_date 

      t.string   :sea_entity, comment: 'Name of the entity'
      t.string   :sea_bill_landing_no
      t.string   :sea_booking_no
      t.string   :sea_containers_no, limit: 4000
      t.string   :sea_departure_city
      t.date     :sea_departure_date
      t.string   :sea_arrival_city
      t.date     :sea_arrival_date

      t.timestamps default: -> {'CURRENT_TIMESTAMP'}
    end

    # Add foreign keys
    add_foreign_key :orders, :companies
    add_foreign_key :orders, :countries, column: :from_country_id
    add_foreign_key :orders, :countries, column: :to_country_id
    add_foreign_key :orders, :entities, column: :client_id
    add_foreign_key :orders, :entities, column: :third_party_id

    # Add indexes
    add_index :orders, [:company_id, :order_no], unique: true

  end
end
