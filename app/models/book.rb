class Book < ApplicationRecord
  belongs_to :author
  belongs_to :book_genre
  has_one_attached :image

  has_many :book_genre_assignments
  has_many :book_genres, through: :book_genre_assignments
  accepts_nested_attributes_for :book_genre_assignments, allow_destroy: true

  validates :title, presence: true
  validates :price, numericality: true
  validates :stock_quantity, numericality: { only_integer: true }
  validates :author, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "author_id", "book_genre_id", "created_at", "description", "id", "id_value", "price", "stock_quantity", "title", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "author", "book_genre", "book_genre_assignments", "book_genres" ]
  end
end
