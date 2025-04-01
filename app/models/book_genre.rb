class BookGenre < ApplicationRecord
  has_many :book_genre_assignments
  has_many :books, through: :book_genre_assignments
end
