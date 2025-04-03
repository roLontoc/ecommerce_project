class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :book, optional: true
  belongs_to :merchandise, optional: true
end
