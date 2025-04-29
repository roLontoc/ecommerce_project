class Author < ApplicationRecord
  has_many :books
  validates :author_name, presence: true
  def to_s
    author_name
  end
end
