class CreateContactPages < ActiveRecord::Migration[8.0]
  def change
    create_table :contact_pages do |t|
      t.timestamps
    end
  end
end
