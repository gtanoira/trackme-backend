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

ActiveRecord::Schema.define(version: 2019_10_26_231680) do

  create_table "api_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "image"
    t.string "email"
    t.text "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_api_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_api_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_api_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_api_users_on_uid_and_provider", unique: true
  end

  create_table "companies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.bigint "holding_id", null: false, comment: "Holding of companies where it belongs"
    t.string "name"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "index_companies_on_country_id"
    t.index ["holding_id"], name: "fk_rails_c8d5ebaea1"
  end

  create_table "countries", id: :string, limit: 3, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "iso2", limit: 2
    t.string "name", limit: 200
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "endpoints", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "pointable_id", null: false, comment: "polymorphic ID"
    t.string "pointable_type", null: false, comment: "polymorphic TYPE: CompanyAddress, EntityAddress, WarehouseAddress"
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
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["country_id"], name: "fk_rails_bcab79c194"
    t.index ["pointable_type", "pointable_id", "name"], name: "index_endpoints_on_pointable_type_and_pointable_id_and_name", unique: true
  end

  create_table "entities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "country_id", limit: 3, default: "NNN", null: false
    t.bigint "company_id", null: false, comment: "Company where it belong"
    t.string "type", default: "Client", null: false, comment: "STI table, entity type: Client, Supplier, Cargo"
    t.string "name"
    t.string "alias", limit: 10, comment: "Short for entity name. Used in QR and stamps"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["alias"], name: "index_entities_on_alias"
    t.index ["company_id"], name: "fk_rails_338f90642c"
    t.index ["country_id"], name: "fk_rails_d9fddbe4c8"
    t.index ["name"], name: "index_entities_on_name"
  end

  create_table "holdings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "menues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "pgm_id", null: false, comment: "Id assign to the program"
    t.string "title", comment: "Program Title"
    t.string "alias", limit: 4, comment: "Alias for the program (4 digits max) to be printed on the menu button"
    t.string "pgm_group", default: "No group", comment: "Group ID where the program belongs to"
    t.string "color", default: "black", comment: "Color for the background button menu"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["pgm_id"], name: "index_menues_on_pgm_id"
  end

  create_table "orders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "client_id", null: false
    t.integer "order_no", null: false
    t.string "type", default: "WarehouseReceipt", null: false, comment: "STI table, values: WarehouseReceipt, Shipment"
    t.string "applicant_name", comment: "Client contact who is responsible for the order"
    t.datetime "cancel_datetime", comment: "Date-Time when the order was cancelled"
    t.string "cancel_user", comment: "User ID who cancelled the order"
    t.string "client_ref", comment: "Client Order Reference"
    t.datetime "delivery_datetime", comment: "Real Delivery Date-Time"
    t.date "eta", comment: "Estimated Time of Arrival"
    t.string "incoterm", limit: 3, comment: "Type of transaction: FOB, etc"
    t.string "legacy_order_no", comment: "Order ID in the legacy system"
    t.text "observations"
    t.datetime "order_datetime", default: -> { "CURRENT_TIMESTAMP" }, null: false, comment: "Date-Time when the order was place into the system"
    t.string "order_status", limit: 1, default: "P", null: false, comment: "(P):pending / (C):confirmed / (F):finished / (A):cancelled"
    t.string "order_type", limit: 1, default: "D", null: false, comment: "(P):pick-up by us / (D):delivery by us / (I):pick-up by client / (E)delivery by client"
    t.integer "pieces", comment: "No. of pieces within the order"
    t.string "shipment_method", limit: 1, default: "A", null: false, comment: "Shipment method: (A):air / (B):boat / (G):ground"
    t.bigint "third_party_id", null: false, comment: "Client to invoice the order"
    t.string "from_entity", comment: "Name of the entity"
    t.text "from_address1"
    t.text "from_address2"
    t.string "from_city"
    t.string "from_zipcode"
    t.string "from_state"
    t.string "from_country_id", limit: 3, default: "NNN", null: false
    t.string "from_contact"
    t.string "from_email"
    t.string "from_tel"
    t.string "to_entity", comment: "Name of the entity"
    t.text "to_address1"
    t.text "to_address2"
    t.string "to_city"
    t.string "to_zipcode"
    t.string "to_state"
    t.string "to_country_id", limit: 3, default: "NNN", null: false
    t.string "to_contact"
    t.string "to_email"
    t.string "to_tel"
    t.string "ground_entity", comment: "Name of the entity"
    t.string "ground_booking_no"
    t.string "ground_departure_city"
    t.date "ground_departure_date"
    t.string "ground_arrival_city"
    t.date "ground_arrival_date"
    t.string "air_entity", comment: "Name of the entity"
    t.string "air_waybill_no"
    t.string "air_departure_city"
    t.date "air_departure_date"
    t.string "air_arrival_city"
    t.date "air_arrival_date"
    t.string "sea_entity", comment: "Name of the entity"
    t.string "sea_bill_landing_no"
    t.string "sea_booking_no"
    t.string "sea_containers_no", limit: 4000
    t.string "sea_departure_city"
    t.date "sea_departure_date"
    t.string "sea_arrival_city"
    t.date "sea_arrival_date"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["client_id"], name: "fk_rails_5c8e53c896"
    t.index ["company_id", "order_no"], name: "index_orders_on_company_id_and_order_no", unique: true
    t.index ["from_country_id"], name: "fk_rails_acc87619e9"
    t.index ["third_party_id"], name: "fk_rails_f26d3c6c1a"
    t.index ["to_country_id"], name: "fk_rails_a030523b10"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "company_id", comment: "Company where it belongs"
    t.string "first_name", comment: "First Name"
    t.string "last_name", comment: "Last Name"
    t.text "authorizations", comment: "User authorizations in JSON format"
    t.index ["company_id"], name: "fk_rails_7682a3bdfe"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "companies", "countries"
  add_foreign_key "companies", "holdings"
  add_foreign_key "endpoints", "countries"
  add_foreign_key "entities", "companies"
  add_foreign_key "entities", "countries"
  add_foreign_key "orders", "companies"
  add_foreign_key "orders", "countries", column: "from_country_id"
  add_foreign_key "orders", "countries", column: "to_country_id"
  add_foreign_key "orders", "entities", column: "client_id"
  add_foreign_key "orders", "entities", column: "third_party_id"
  add_foreign_key "users", "companies"
end
