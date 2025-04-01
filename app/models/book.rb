class Book < ApplicationRecord
  belongs_to :author
  belongs_to :book_genre

  has_many :book_genre_assignments
  has_many :book_genres, through: :book_genre_assignments
end
