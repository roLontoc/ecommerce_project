class AddProvinceRefToCustomers < ActiveRecord::Migration[8.0]
  def change
    add_reference :customers, :province, null: false, foreign_key: true, null: true
  end
end
