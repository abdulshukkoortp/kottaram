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

ActiveRecord::Schema.define(version: 20170809060112) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "max_no_of_user_per_group"
    t.integer  "max_nof_groups"
    t.text     "rules"
    t.float    "interval"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "event_id"
    t.boolean  "active",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "status",     default: 0
    t.integer  "slot",       default: 0
    t.date     "event_date"
  end

  create_table "house_infos", force: :cascade do |t|
    t.integer  "name"
    t.datetime "agreement_created"
    t.integer  "agreement_validity"
    t.datetime "agreement_extended_at"
    t.integer  "extension_period"
    t.float    "rent"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "payment_statuses", force: :cascade do |t|
    t.integer  "user_id"
    t.boolean  "paid",       default: false
    t.text     "year_month"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "penalties", force: :cascade do |t|
    t.integer  "user_id"
    t.date     "date"
    t.integer  "type"
    t.float    "amount"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "creator_id"
    t.integer  "approver_id"
    t.integer  "status",      default: 0
    t.text     "description"
  end

  create_table "splitwises", force: :cascade do |t|
    t.datetime "purchased_at"
    t.integer  "created_by"
    t.float    "price"
    t.string   "item_name"
    t.text     "description"
    t.float    "quantity"
    t.float    "remaining_quantity"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "purchased_by"
  end

  create_table "user_groups", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "full_name"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.boolean  "active",                 default: true
    t.datetime "de_activated_at"
    t.datetime "joined_at"
    t.integer  "role",                   default: 0
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end
