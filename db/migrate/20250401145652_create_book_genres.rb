class CreateBookGenres < ActiveRecord::Migration[8.0]
  def change
    create_table :book_genres do |t|
      t.string :genre_name

      t.timestamps
    end
  end
end
