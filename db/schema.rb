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

ActiveRecord::Schema[8.0].define(version: 2025_04_01_194250) do
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

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.index ["customer_id"], name: "index_orders_on_customer_id"
  end

  add_foreign_key "book_genre_assignments", "book_genres"
  add_foreign_key "book_genre_assignments", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "book_genres"
  add_foreign_key "merchandises", "merchandise_categories"
  add_foreign_key "order_items", "books"
  add_foreign_key "order_items", "merchandises"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "customers"
end
