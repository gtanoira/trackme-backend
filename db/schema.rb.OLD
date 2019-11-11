# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_24_163449) do

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name"
    t.string "address1", limit: 4000
    t.string "address2", limit: 4000
    t.string "city"
    t.string "zipcode"
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "index_companies_on_country_id"
  end

  create_table "customer_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "customer_id", null: false
    t.integer "order_no", null: false
    t.date "order_date", null: false
    t.text "observations"
    t.string "cust_ref", comment: "Customer Order ID"
    t.string "order_type", limit: 1, default: "D", null: false, comment: "(P):pick-up by Co. / (D):delivery by Co. / (I):pick-up by client / (E)delivery by client"
    t.string "order_status", limit: 1, default: "P", null: false, comment: "(P):pending / (C):confirmed / (F):finished / (A):cancelled"
    t.datetime "cancel_date", comment: "Date when the order was cancelled"
    t.string "cancel_user", comment: "User ID who cancelled the order"
    t.string "applicant_name", comment: "Customer person who is responsible for the order"
    t.string "old_order_no", comment: "Order ID No. for the legacy system"
    t.string "incoterm", limit: 3, comment: "Type of transaction: FOB, etc"
    t.string "shipment_method", limit: 1, default: "A", comment: "Shipment method: (A):air / (B):boat / (G):ground"
    t.date "eta", comment: "Estimated Time of Arrival"
    t.date "delivery_date", comment: "Real Delivery Date"
    t.string "from_entity", null: false
    t.text "from_address1"
    t.text "from_address2"
    t.string "from_city"
    t.string "from_zipcode"
    t.string "from_state"
    t.string "from_country_id", limit: 3, null: false
    t.string "from_contact"
    t.string "from_email"
    t.string "from_tel"
    t.string "to_entity", null: false
    t.text "to_address1"
    t.text "to_address2"
    t.string "to_city"
    t.string "to_zipcode"
    t.string "to_state"
    t.string "to_country_id", limit: 3, null: false
    t.string "to_contact"
    t.string "to_email"
    t.string "to_tel"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.integer "pieces"
    t.string "events_scope", limit: 1, default: "G", comment: "For tracking purpose. Where to show only (G)lobal or (P)artial events to clients"
    t.bigint "third_party_id", null: false, comment: "Entity ID to invoice the customer_orders"
    t.index ["company_id", "order_no"], name: "index_customer_orders_on_company_id_and_order_no", unique: true
    t.index ["customer_id"], name: "fk_rails_13f33fda6c"
    t.index ["from_country_id"], name: "fk_rails_2ed680419e"
    t.index ["third_party_id"], name: "fk_rails_e413f704ab"
    t.index ["to_country_id"], name: "fk_rails_a79b35e352"
  end

  create_table "endpoints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "type", comment: "Type of endpoint: Company, Entity, Order"
    t.string "name"
    t.string "address1", limit: 4000
    t.string "address2", limit: 4000
    t.string "city"
    t.string "zipcode"
    t.string "state"
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.string "contact"
    t.string "email"
    t.string "tel"
    t.index ["country_id"], name: "fk_rails_bcab79c194"
    t.index ["type", "name"], name: "index_endpoints_on_type_and_name", unique: true
  end

  create_table "entities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name"
    t.string "address1", limit: 4000
    t.string "address2", limit: 4000
    t.string "city"
    t.string "zipcode"
    t.string "state"
    t.string "alias", limit: 10
    t.string "entity_type", limit: 3, default: "CUS", null: false, comment: "Entity type: (CUS)customer, (PRO)provider, (CAR)cargo"
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.bigint "company_id", comment: "Use for Migration purpose only, to set all the CustomerOrders company_id field"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "fk_rails_d9fddbe4c8"
    t.index ["name"], name: "index_entities_on_name"
  end

  create_table "entity_addresses", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "entity", null: false
    t.string "address1", limit: 4000
    t.string "address2", limit: 4000
    t.string "city"
    t.string "zipcode"
    t.string "state"
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.string "contact"
    t.string "email"
    t.string "tel"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "fk_rails_1bdcb1b84d"
    t.index ["entity"], name: "index_entity_addresses_on_entity", unique: true
  end

  create_table "event_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "tracking_milestone_id"
    t.string "tracking_milestone_css_color", comment: "This color if present, will override the actual color of the tracking line milestone"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["tracking_milestone_id"], name: "fk_rails_e553555a81"
  end

  create_table "internal_orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "customer_id", null: false
    t.integer "order_no", null: false
    t.date "order_date", null: false
    t.text "observations"
    t.string "order_type", limit: 1, default: "D", null: false, comment: "(P):pick-up by Co. / (D):delivery by Co. / (I):pick-up by client / (E)delivery by client"
    t.string "order_status", limit: 1, default: "P", null: false, comment: "(P):pending / (C):confirmed / (F):finished / (A):cancelled"
    t.datetime "cancel_date", comment: "Date when the order was cancelled"
    t.string "cancel_user", comment: "User ID who cancelled the order"
    t.string "shipment_method", limit: 1, default: "A", comment: "Shipment method: (A):air / (B):boat / (G):ground"
    t.date "eta", comment: "Estimated Time of Arrival"
    t.date "delivery_date", comment: "Real Delivery Date"
    t.integer "pieces", comment: "No. of pieces within the order"
    t.string "from_entity", null: false
    t.text "from_address1"
    t.text "from_address2"
    t.string "from_city"
    t.string "from_zipcode"
    t.string "from_state"
    t.string "from_country_id", limit: 3, default: "NNN", null: false
    t.string "from_contact"
    t.string "from_email"
    t.string "from_tel"
    t.string "to_entity", null: false
    t.text "to_address1"
    t.text "to_address2"
    t.string "to_city"
    t.string "to_zipcode"
    t.string "to_state"
    t.string "to_country_id", limit: 3, default: "NNN", null: false
    t.string "to_contact"
    t.string "to_email"
    t.string "to_tel"
    t.string "ground_entity", null: false
    t.string "ground_booking_no"
    t.string "ground_departure_city"
    t.date "ground_departure_date"
    t.string "ground_arrival_city"
    t.date "ground_arrival_date"
    t.string "air_entity", null: false
    t.string "air_waybill_no"
    t.string "air_departure_city"
    t.date "air_departure_date"
    t.string "air_arrival_city"
    t.date "air_arrival_date"
    t.string "sea_entity", null: false
    t.string "sea_bill_landing_no"
    t.string "sea_booking_no"
    t.string "sea_containers_no", limit: 4000
    t.string "sea_departure_city"
    t.date "sea_departure_date"
    t.string "sea_arrival_city"
    t.date "sea_arrival_date"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "customer_order_id", comment: "Customer Order ID which this order belongs to"
    t.string "type", default: "WarehouseReceipt", null: false, comment: "Type of order: WarehouseReceipt or Shipment"
    t.index ["company_id", "order_no"], name: "index_internal_orders_on_company_id_and_order_no", unique: true
    t.index ["customer_id"], name: "fk_rails_3469cdcd56"
    t.index ["customer_order_id"], name: "fk_rails_32d63344a3"
    t.index ["from_country_id"], name: "fk_rails_6db79d052f"
    t.index ["to_country_id"], name: "fk_rails_bf5c448ad5"
  end

  create_table "iso_countries", id: :string, limit: 3, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "iso2", limit: 2
    t.string "name", limit: 200
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "items", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "customer_id", null: false
    t.string "item_id", null: false, comment: "This is the ID that goes in the sticker attached to the box"
    t.bigint "internal_order_id", null: false, comment: "Internal order ID where this item belongs to"
    t.string "item_type", limit: 4, default: "Box", null: false, comment: "Determines the type of content of the Item (enum)"
    t.string "status", limit: 9, default: "OnHand", null: false, comment: "Specifies the actual status of the item in the process of delivering (enum)"
    t.string "deleted_by"
    t.string "deleted_cause"
    t.string "manufacter"
    t.string "model"
    t.string "part_number"
    t.string "serial_number"
    t.string "ua_number"
    t.string "condition", limit: 8, default: "Original", null: false, comment: "Item type: new, used, etc. (enum)"
    t.text "contents", limit: 4294967295
    t.string "unit_length", limit: 4, default: "cm", null: false, comment: "Unit of measure for distance (enum)"
    t.decimal "width", precision: 9, scale: 2
    t.decimal "height", precision: 9, scale: 2
    t.decimal "length", precision: 9, scale: 2
    t.string "unit_weight", limit: 6, default: "kg", null: false, comment: "Unit of measure for weight (enum)"
    t.decimal "weight", precision: 9, scale: 2
    t.string "unit_volume", limit: 3, default: "m3", null: false, comment: "Unit of measure for volume weight (enum)"
    t.decimal "volume_weight", precision: 9, scale: 2
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["company_id"], name: "fk_rails_ad750f090b"
    t.index ["customer_id"], name: "fk_rails_0dfe9122fd"
    t.index ["internal_order_id"], name: "fk_rails_930ae8c673"
    t.index ["item_id", "company_id"], name: "index_items_on_item_id_and_company_id", unique: true
  end

  create_table "menues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "pgm_id", null: false, comment: "Id assign to the program"
    t.string "title", comment: "Program description"
    t.string "alias", limit: 4, comment: "Alias for the program (4 digits max) to be printed on the menu button"
    t.string "pgm_group", default: "No group", comment: "Group ID where the program belongs to"
    t.string "color", default: "black", comment: "Color for the background button menu"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pgm_id"], name: "index_menues_on_pgm_id"
  end

  create_table "order_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "event_type_id", null: false
    t.bigint "user_id", null: false, comment: "User ID who creates the event"
    t.string "type", default: "CustomerOrderEvent", null: false, comment: "Type of event: CustomerOrderEvent, WarehouseReceiptEvent or ShipmentEvent"
    t.bigint "customer_order_id", null: false
    t.datetime "event_datetime"
    t.string "observations", limit: 1000
    t.string "event_scope", limit: 3, default: "PRI", comment: "(PRI):private, only visible by the company / (PUB):visible by all, company and customer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_type_id"], name: "fk_rails_68e8263fd7"
    t.index ["user_id"], name: "fk_rails_21d02ca34e"
  end

  create_table "tracking_milestones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name"
    t.integer "place_order"
    t.string "css_color"
    t.string "description"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", comment: "First Name"
    t.string "last_name", comment: "Last Name"
    t.text "authorizations", comment: "User authorizations"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "iso_countries", column: "country_id"
  add_foreign_key "customer_orders", "companies"
  add_foreign_key "customer_orders", "entities", column: "customer_id"
  add_foreign_key "customer_orders", "entities", column: "third_party_id"
  add_foreign_key "customer_orders", "iso_countries", column: "from_country_id"
  add_foreign_key "customer_orders", "iso_countries", column: "to_country_id"
  add_foreign_key "endpoints", "iso_countries", column: "country_id"
  add_foreign_key "entities", "iso_countries", column: "country_id"
  add_foreign_key "entity_addresses", "iso_countries", column: "country_id"
  add_foreign_key "event_types", "tracking_milestones"
  add_foreign_key "internal_orders", "companies"
  add_foreign_key "internal_orders", "customer_orders"
  add_foreign_key "internal_orders", "entities", column: "customer_id"
  add_foreign_key "internal_orders", "iso_countries", column: "from_country_id"
  add_foreign_key "internal_orders", "iso_countries", column: "to_country_id"
  add_foreign_key "items", "companies"
  add_foreign_key "items", "entities", column: "customer_id"
  add_foreign_key "items", "internal_orders"
  add_foreign_key "order_events", "event_types"
  add_foreign_key "order_events", "users"
end
