class BookGenreAssignment < ApplicationRecord
  belongs_to :book
  belongs_to :book_genre

  def self.ransackable_attributes(auth_object = nil)
    [ "book_genre_id", "book_id", "created_at", "id", "id_value", "updated_at" ]
  end
end
