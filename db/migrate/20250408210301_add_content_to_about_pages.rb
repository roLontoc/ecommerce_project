class AddContentToAboutPages < ActiveRecord::Migration[8.0]
  def change
    add_column :about_pages, :content, :text
  end
end
