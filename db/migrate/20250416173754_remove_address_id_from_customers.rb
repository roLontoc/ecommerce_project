class RemoveAddressIdFromCustomers < ActiveRecord::Migration[8.0]
  def change
    remove_column :customers, :address_id, :integer
  end
end
