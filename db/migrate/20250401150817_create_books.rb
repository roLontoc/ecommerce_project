class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :description
      t.decimal :price
      t.integer :stock_quantity
      t.references :author, null: false, foreign_key: true
      t.references :book_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
