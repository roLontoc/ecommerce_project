class MerchandiseCategory < ApplicationRecord
has_many :merchandise
validates :category_name, presence: true
end
