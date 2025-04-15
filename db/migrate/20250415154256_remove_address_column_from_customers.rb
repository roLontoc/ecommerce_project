class RemoveAddressColumnFromCustomers < ActiveRecord::Migration[8.0]
  def change
    remove_column :customers, :address, :string
  end
end
