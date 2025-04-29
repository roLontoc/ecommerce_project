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

ActiveRecord::Schema[8.0].define(version: 2025_04_17_164835) do
  create_table "about_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.integer "resource_id"
    t.string "author_type"
    t.integer "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "city"
    t.integer "province_id", null: false
    t.string "postal_code"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_addresses_on_customer_id"
    t.index ["province_id"], name: "index_addresses_on_province_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "authors", force: :cascade do |t|
    t.string "author_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_genre_assignments", force: :cascade do |t|
    t.integer "book_id", null: false
    t.integer "book_genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_genre_id"], name: "index_book_genre_assignments_on_book_genre_id"
    t.index ["book_id"], name: "index_book_genre_assignments_on_book_id"
  end

  create_table "book_genres", force: :cascade do |t|
    t.string "genre_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.decimal "price"
    t.integer "stock_quantity"
    t.integer "author_id", null: false
    t.integer "book_genre_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_books_on_author_id"
    t.index ["book_genre_id"], name: "index_books_on_book_genre_id"
  end

  create_table "contact_pages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
  end

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "province_id"
    t.index ["email"], name: "index_customers_on_email", unique: true
    t.index ["province_id"], name: "index_customers_on_province_id"
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true
  end

  create_table "merchandise_categories", force: :cascade do |t|
    t.string "category_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "merchandises", force: :cascade do |t|
    t.string "merch_name"
    t.string "description"
    t.decimal "price"
    t.integer "stock_quantity"
    t.integer "merchandise_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchandise_category_id"], name: "index_merchandises_on_merchandise_category_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "quantity"
    t.decimal "price_at_order"
    t.integer "order_id", null: false
    t.integer "book_id"
    t.integer "merchandise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_order_items_on_book_id"
    t.index ["merchandise_id"], name: "index_order_items_on_merchandise_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.date "order_date"
    t.decimal "order_tax"
    t.decimal "order_total"
    t.integer "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "order_number"
    t.string "status"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
  end

  create_table "provinces", force: :cascade do |t|
    t.string "name"
    t.decimal "pst_rate"
    t.decimal "gst_rate"
    t.decimal "hst_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "customers"
  add_foreign_key "addresses", "provinces"
  add_foreign_key "book_genre_assignments", "book_genres"
  add_foreign_key "book_genre_assignments", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "book_genres"
  add_foreign_key "customers", "provinces"
  add_foreign_key "merchandises", "merchandise_categories"
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "merchandises"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "customers"
end
