class BookGenre < ApplicationRecord
  has_many :book_genre_assignments
  has_many :books, through: :book_genre_assignments
  validates :genre_name, presence: true
  def to_s
    genre_name
  end
end
