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

ActiveRecord::Schema.define(version: 2018_09_04_040949) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.string "reference", null: false
    t.decimal "price", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.string "provider"
    t.float "tax"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tariffs", force: :cascade do |t|
    t.string "driver_name", null: false
    t.string "vehicle_plate", null: false
    t.string "shift_name"
    t.date "shift_date"
    t.integer "status", default: 0, null: false
    t.decimal "owner_tariff", null: false
    t.decimal "paid", null: false
    t.decimal "debt", null: false
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taxes", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "percentage", null: false
    t.string "tax_type", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "terms", force: :cascade do |t|
    t.string "name", null: false
    t.integer "days", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.string "name", null: false
    t.string "telephone", null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  create_table "withholdings", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "percentage", null: false
    t.string "withholding_type", null: false
    t.integer "status", default: 0, null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
