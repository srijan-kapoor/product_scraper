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

ActiveRecord::Schema[7.1].define(version: 2025_02_22_105107) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.string "size"
    t.string "price"
    t.string "seller_name"
    t.jsonb "metadata"
    t.string "product_id", null: false
    t.string "url", null: false
    t.string "image_url"
    t.bigint "category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_scraped_at"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["product_id"], name: "index_products_on_product_id", unique: true
    t.index ["url"], name: "index_products_on_url", unique: true
  end

  add_foreign_key "products", "categories"
end
