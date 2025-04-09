class AddContentToContactPages < ActiveRecord::Migration[8.0]
  def change
    add_column :contact_pages, :content, :text
  end
end
