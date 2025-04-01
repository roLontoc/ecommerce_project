class Book < ApplicationRecord
  belongs_to :author
  belongs_to :book_genre

  has_many :book_genres, through: :book_genres
  has_many :order_items, through: :order_items
end
