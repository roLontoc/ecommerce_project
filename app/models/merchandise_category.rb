class MerchandiseCategory < ApplicationRecord
has_many :merchandise
validates :category_name, presence: true
def to_s
  category_name
end
end
