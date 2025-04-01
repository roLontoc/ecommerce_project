class BookGenreAssignment < ApplicationRecord
  belongs_to :book
  belongs_to :book_genre
end
