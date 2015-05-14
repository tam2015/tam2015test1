# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150514002306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "accounts", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "boxes_count", default: 0, null: false
  end

  create_table "aircrm_preferences", force: true do |t|
    t.string   "preference_type"
    t.text     "data"
    t.integer  "account_id"
    t.integer  "dashboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boxes", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "closed",                       default: false
    t.decimal  "price"
    t.boolean  "favorite",                     default: false
    t.integer  "account_id"
    t.integer  "customer_id"
    t.integer  "dashboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "meli_order_id"
    t.string   "status",                       default: "0"
    t.datetime "closed_at"
    t.integer  "user_id"
    t.string   "meli_item_id",      limit: 40
    t.string   "tags",                                         array: true
    t.string   "meli_date_created"
    t.string   "meli_date_closed"
    t.string   "meli_last_updated"
    t.integer  "item_quantity"
    t.integer  "meli_variation_id", limit: 8
    t.text     "manual_variation"
  end

  add_index "boxes", ["meli_order_id", "meli_item_id"], name: "index_boxes_on_meli_order_id_and_meli_item_id", using: :btree

  create_table "canned_responses", force: true do |t|
    t.text     "answer"
    t.string   "tag"
    t.integer  "account_id"
    t.integer  "dashboard_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.string   "nickname"
    t.string   "phone"
    t.string   "email"
    t.integer  "meli_user_id"
    t.integer  "user_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "blocked",         default: false
    t.string   "pendings_status"
    t.string   "pendings",                        array: true
    t.text     "billing_info"
  end

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "provider",           limit: 20
    t.integer  "meli_user_id"
    t.string   "token"
    t.string   "refresh_token"
    t.string   "token_expires_at"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "synced_at"
    t.hstore   "preferences"
    t.integer  "boxes_count",                   default: 0, null: false
    t.string   "meli_user_username", limit: 40
  end

  create_table "datastores", force: true do |t|
    t.string "from"
    t.string "klass"
    t.string "meli_id"
    t.text   "json"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "rating"
    t.boolean  "fulfilled"
    t.string   "reason"
    t.string   "message"
    t.string   "reply"
    t.string   "status"
    t.string   "author_type"
    t.integer  "meli_feedback_id",  limit: 8
    t.string   "meli_item_id",      limit: 15
    t.integer  "meli_order_id",     limit: 8
    t.integer  "dashboard_id"
    t.boolean  "updated",                      default: false
    t.boolean  "restock_item",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meli_date_created"
  end

  add_index "feedbacks", ["meli_order_id", "author_type"], name: "index_feedbacks_on_meli_order_id_and_author_type", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.integer  "meli_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meli_user_username"
  end

  add_index "identities", ["user_id"], name: "index_identities_on_user_id", using: :btree

  create_table "item_storages", force: true do |t|
    t.integer  "initial_quantity"
    t.integer  "available_quantity"
    t.integer  "sold_quantity"
    t.integer  "unpublished_quantity"
    t.integer  "item_id"
    t.integer  "variation_id",         limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "item_storages", ["variation_id"], name: "index_item_storages_on_variation_id", using: :btree

  create_table "items", force: true do |t|
    t.integer  "buying_mode"
    t.string   "category_id"
    t.string   "condition"
    t.string   "title"
    t.text     "description"
    t.string   "warranty"
    t.float    "price"
    t.float    "base_price"
    t.string   "video_id"
    t.integer  "listing_type_id"
    t.integer  "status"
    t.string   "seller_custom_field"
    t.boolean  "automatic_relist",               default: false
    t.integer  "dashboard_id"
    t.integer  "account_id"
    t.string   "meli_item_id",        limit: 15
    t.string   "official_store_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "items", ["meli_item_id", "status"], name: "index_items_on_meli_item_id_and_status", using: :btree

  create_table "labels", force: true do |t|
    t.string  "aircrm_date_printed"
    t.string  "meli_first_date_printed"
    t.integer "shipping_id"
  end

  create_table "meli_infos", force: true do |t|
    t.integer  "item_id"
    t.boolean  "accepts_mercadopago"
    t.text     "non_mercado_pago_payment_methods"
    t.text     "shipping",                         default: "---\n:mode: not_specified\n:local_pick_up: false\n:free_shipping: false\n:methods: []\n:costs: []\n:dimensions: \n"
    t.text     "seller_address"
    t.text     "geolocation"
    t.integer  "validation_code"
    t.string   "validation_status",                default: "invalid"
    t.string   "validation_errors",                                                                                                                                               array: true
    t.string   "site_id"
    t.string   "currency_id",                      default: "BRL"
    t.string   "permalink"
    t.string   "thumbnail"
    t.string   "secure_thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meli_start_time"
    t.string   "meli_stop_time"
    t.string   "meli_end_time"
    t.string   "meli_last_updated"
  end

  create_table "notifies", force: true do |t|
    t.integer  "param"
    t.integer  "delivery_method"
    t.integer  "status"
    t.time     "email_delivered_at"
    t.time     "sms_delivered_at"
    t.integer  "dashboard_id"
    t.integer  "box_id"
    t.integer  "meli_order_id"
    t.string   "reference_id"
    t.string   "reference_model"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notify_agents", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.string   "nickname"
    t.string   "email"
    t.string   "phone"
    t.integer  "meli_user_id"
    t.string   "type"
    t.integer  "notify_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_notifications", force: true do |t|
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.string   "paypal_customer_token"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subscription_id"
  end

  create_table "payments", force: true do |t|
    t.integer  "status"
    t.integer  "meli_payment_id",    limit: 8
    t.integer  "box_id"
    t.integer  "dashboard_id"
    t.integer  "meli_order_id",      limit: 8
    t.integer  "user_id"
    t.boolean  "accept_mercadopago",           default: false
    t.string   "tags",                                         array: true
    t.string   "payment_method_id"
    t.integer  "installments"
    t.float    "transaction_amount"
    t.float    "shipping_cost"
    t.float    "overpaid_amount"
    t.float    "total_paid_amount"
    t.string   "card_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["meli_payment_id", "meli_order_id", "box_id"], name: "index_payments_on_meli_payment_id_and_meli_order_id_and_box_id", using: :btree

  create_table "pictures", force: true do |t|
    t.integer  "item_id"
    t.string   "meli_id"
    t.text     "meli_url"
    t.text     "meli_secure_url"
    t.string   "meli_size"
    t.string   "meli_max_size"
    t.string   "quality"
    t.text     "source"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "cwave"
  end

  add_index "pictures", ["meli_url"], name: "index_pictures_on_meli_url", using: :btree

  create_table "plans", force: true do |t|
    t.string   "name"
    t.string   "price"
    t.string   "collaborator"
    t.string   "dashboard"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", force: true do |t|
    t.integer  "status"
    t.string   "meli_item_id",         limit: 15
    t.text     "text"
    t.integer  "meli_question_id",     limit: 8
    t.boolean  "hold"
    t.boolean  "deleted_from_listing"
    t.text     "answer"
    t.integer  "dashboard_id"
    t.integer  "user_id"
    t.integer  "author_id",            limit: 8
    t.integer  "seller_id",            limit: 8
    t.boolean  "customer_blocked",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "meli_date_created"
  end

  add_index "questions", ["meli_question_id", "meli_item_id"], name: "index_questions_on_meli_question_id_and_meli_item_id", using: :btree

  create_table "schedules", force: true do |t|
    t.string   "title"
    t.string   "address"
    t.text     "note"
    t.datetime "date_time"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "shippings", force: true do |t|
    t.integer  "meli_shipping_id",       limit: 8
    t.integer  "status"
    t.integer  "shipment_type"
    t.string   "shipping_mode"
    t.string   "substatus"
    t.string   "currency_id"
    t.float    "cost"
    t.string   "date_first_printed"
    t.string   "service_id"
    t.string   "receiver_address_s"
    t.text     "receiver_address"
    t.string   "coordinates",                                       array: true
    t.text     "sender_address"
    t.string   "tracking_number"
    t.string   "tracking_method"
    t.string   "return_tracking_number"
    t.time     "updated_by_buyer_at"
    t.integer  "box_id"
    t.integer  "dashboard_id"
    t.string   "meli_item_id",           limit: 15
    t.integer  "meli_order_id",          limit: 8
    t.integer  "user_id"
    t.string   "pendings",                                          array: true
    t.string   "pendings_status"
    t.boolean  "updated_by_seller",                 default: false
    t.boolean  "updated_by_customer",               default: false
    t.boolean  "accept_mercadoenvios",              default: false
    t.string   "tags",                                              array: true
    t.string   "date_shipped"
    t.string   "date_delivered"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shippings", ["meli_order_id", "box_id"], name: "index_shippings_on_meli_order_id_and_box_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "paypal_customer_token"
    t.string   "paypal_recurring_profile_token"
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.datetime "expires_in"
  end

  create_table "users", force: true do |t|
    t.string   "email",                             default: "",        null: false
    t.string   "encrypted_password",                default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "meli_user_username",     limit: 40
    t.string   "phone"
    t.string   "role",                              default: "regular"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",                 default: 0
    t.hstore   "address"
    t.string   "codigo"
    t.string   "filial"
    t.string   "razaosocial"
    t.string   "fantasia"
    t.string   "cnpj"
    t.hstore   "telefone"
    t.string   "tipo_cliente"
    t.hstore   "id_brands"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "dashboards_count",                  default: 0,         null: false
    t.string   "image"
    t.string   "website"
    t.string   "alternative_email"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_to_customers", force: true do |t|
    t.integer  "customer_id"
    t.integer  "user_id"
    t.boolean  "blocked_to_questions", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users_to_dashboards", force: true do |t|
    t.integer  "user_id"
    t.integer  "dashboard_id"
    t.string   "role",         default: "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users_to_dashboards", ["dashboard_id"], name: "index_users_to_dashboards_on_dashboard_id", using: :btree
  add_index "users_to_dashboards", ["user_id"], name: "index_users_to_dashboards_on_user_id", using: :btree

  create_table "variation_to_types", force: true do |t|
    t.integer  "variation_type_id"
    t.integer  "variation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variation_types", force: true do |t|
    t.string   "meli_id"
    t.string   "meli_name"
    t.string   "meli_value_id"
    t.string   "meli_value_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variation_types", ["meli_id"], name: "index_variation_types_on_meli_id", using: :btree

  create_table "variations", force: true do |t|
    t.integer  "item_id"
    t.float    "price"
    t.text     "meli_picture_ids",              array: true
    t.integer  "meli_variation_id",   limit: 8
    t.string   "seller_custom_field"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "variations", ["meli_variation_id"], name: "index_variations_on_meli_variation_id", using: :btree

end
