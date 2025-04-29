class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :book, optional: true
  belongs_to :merchandise, optional: true

  def self.ransackable_attributes(auth_object = nil)
    [ "book_id", "created_at", "id", "id_value", "merchandise_id", "order_id", "price_at_order", "quantity", "updated_at" ]
  end
end
