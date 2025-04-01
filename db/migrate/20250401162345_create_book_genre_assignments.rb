class CreateBookGenreAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :book_genre_assignments do |t|
      t.references :book, null: false, foreign_key: true
      t.references :book_genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
