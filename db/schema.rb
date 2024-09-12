# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_09_11_225335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "link_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "link_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["link_id"], name: "index_link_tags_on_link_id"
    t.index ["tag_id"], name: "index_link_tags_on_tag_id"
  end

  create_table "links", force: :cascade do |t|
    t.string "original"
    t.string "short"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "click_count", default: 0
    t.datetime "last_click"
    t.boolean "disabled", default: false
    t.boolean "private", default: false
    t.index ["user_id"], name: "index_links_on_user_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "link_tags", "links"
  add_foreign_key "link_tags", "tags"
  add_foreign_key "links", "users"
end
