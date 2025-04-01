class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.integer :quantity
      t.string :price_at_order
      t.string :decimal
      t.references :order, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.references :merchandise, null: false, foreign_key: true

      t.timestamps
    end
  end
end
