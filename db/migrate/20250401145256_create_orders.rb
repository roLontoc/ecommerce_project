class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.date :order_date
      t.decimal :order_tax
      t.decimal :order_total
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
