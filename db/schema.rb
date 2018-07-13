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

ActiveRecord::Schema.define(version: 2018_07_13_152533) do

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.text "notes"
    t.string "age"
    t.integer "condition", default: 4
    t.integer "price"
    t.string "image"
    t.text "tags"
    t.integer "unavailable", default: 0
    t.integer "total", default: 0
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_items_on_category_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "read_at"
    t.integer "importance"
    t.string "notif_type"
    t.string "head"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "request_items", force: :cascade do |t|
    t.integer "item_id"
    t.integer "request_id"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_request_items_on_item_id"
    t.index ["request_id"], name: "index_request_items_on_request_id"
  end

  create_table "requests", force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "checkout_time"
    t.datetime "picked_up_at"
    t.datetime "returned_at"
    t.text "reason"
    t.text "notes"
    t.date "need_by"
    t.date "return_by"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "rejected", default: false
    t.text "rejected_msg"
    t.string "return_condition"
    t.integer "reviewed_by_id"
    t.integer "checked_in_by_id"
    t.integer "checked_out_by_id"
    t.datetime "reviewed_at"
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.integer "permission_level", default: 0
    t.integer "current_request_id"
    t.string "password_digest"
    t.string "confirm_token"
    t.boolean "email_confirmed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "receive_email_notifications", default: true
    t.string "password_reset_token_digest"
  end

end
