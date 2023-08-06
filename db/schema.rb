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

ActiveRecord::Schema.define(version: 2023_08_06_155147) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "helpers", id: :serial, force: :cascade do |t|
    t.datetime "last_update"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "libraries", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "url"
    t.string "version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "intro"
    t.string "right_msg"
    t.integer "pdf_max"
    t.integer "recommended"
    t.integer "recommended_public"
    t.integer "documents_all"
    t.integer "documents_public"
    t.integer "pages_all"
    t.integer "pages_public"
    t.integer "android", default: 0
    t.integer "ios", default: 0
    t.boolean "k4_client", default: true
    t.string "alt_client_url"
    t.boolean "alt_client_universal", default: false
    t.boolean "k5_client", default: false
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.string "web"
    t.string "name_en"
    t.string "city"
    t.string "street"
    t.string "zip"
    t.float "longitude"
    t.float "latitude"
    t.string "new_client_url"
    t.string "sigla"
    t.string "oai_provider"
    t.boolean "alive", default: false
    t.integer "collections"
    t.integer "model_monograph_all"
    t.integer "model_monograph_public"
    t.integer "model_periodical_all"
    t.integer "model_periodical_public"
    t.integer "model_soundrecording_all"
    t.integer "model_soundrecording_public"
    t.integer "model_map_all"
    t.integer "model_map_public"
    t.integer "model_graphic_all"
    t.integer "model_graphic_public"
    t.integer "model_sheetmusic_all"
    t.integer "model_sheetmusic_public"
    t.integer "model_archive_all"
    t.integer "model_archive_public"
    t.integer "model_manuscript_all"
    t.integer "model_manuscript_public"
    t.integer "model_article_all"
    t.integer "model_article_public"
    t.datetime "last_document_at"
    t.integer "model_periodicalitem_all"
    t.integer "model_periodicalitem_public"
    t.integer "model_supplement_all"
    t.integer "model_supplement_public"
    t.integer "model_periodicalvolume_all"
    t.integer "model_periodicalvolume_public"
    t.integer "model_monographunit_all"
    t.integer "model_monographunit_public"
    t.integer "model_track_all"
    t.integer "model_track_public"
    t.integer "model_soundunit_all"
    t.integer "model_soundunit_public"
    t.integer "model_internalpart_all"
    t.integer "model_internalpart_public"
    t.integer "model_convolute_all"
    t.integer "model_convolute_public"
    t.integer "model_picture_all"
    t.integer "model_picture_public"
    t.string "new_client_version"
    t.string "licenses"
    t.datetime "last_state_switch"
    t.integer "outage_warning_counter", default: 0
    t.string "outage_warning_emails", default: ""
  end

  create_table "records", id: :serial, force: :cascade do |t|
    t.integer "library_id"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "documents_all"
    t.integer "documents_public"
    t.integer "pages_all"
    t.integer "pages_public"
    t.string "version"
    t.integer "inc_documents_all", default: 0
    t.integer "inc_documents_public", default: 0
    t.integer "inc_pages_all", default: 0
    t.integer "inc_pages_public", default: 0
    t.index ["library_id"], name: "index_records_on_library_id"
  end

  create_table "states", force: :cascade do |t|
    t.bigint "library_id"
    t.integer "value"
    t.datetime "at"
    t.index ["library_id"], name: "index_states_on_library_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "records", "libraries"
  add_foreign_key "states", "libraries"
end
