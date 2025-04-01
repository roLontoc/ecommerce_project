class CreateMerchandises < ActiveRecord::Migration[8.0]
  def change
    create_table :merchandises do |t|
      t.string :merch_name
      t.string :description
      t.decimal :price
      t.integer :stock_quantity
      t.references :merchandise_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
