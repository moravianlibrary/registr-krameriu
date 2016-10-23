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

ActiveRecord::Schema.define(version: 20161023113622) do

  create_table "helpers", force: :cascade do |t|
    t.datetime "last_update"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "libraries", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.string   "url"
    t.string   "version"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email"
    t.string   "intro"
    t.string   "right_msg"
    t.integer  "pdf_max"
    t.integer  "recommended"
    t.integer  "recommended_public"
    t.integer  "documents_all"
    t.integer  "documents_public"
    t.integer  "pages_all"
    t.integer  "pages_public"
    t.integer  "android",              default: 0
    t.integer  "ios",                  default: 0
    t.boolean  "k4_client",            default: true
    t.string   "alt_client_url"
    t.boolean  "alt_client_universal", default: false
    t.boolean  "k5_client",            default: false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "web"
    t.string   "name_en"
    t.string   "city"
    t.string   "street"
    t.string   "zip"
    t.float    "longitude"
    t.float    "latitude"
  end

  create_table "users", force: :cascade do |t|
    t.string   "login"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
