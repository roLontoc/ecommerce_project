class Merchandise < ApplicationRecord
  belongs_to :merchandise_category
  has_one_attached :image


  def self.ransackable_associations(auth_object = nil)
    [ "merchandise_category" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "description", "id", "id_value", "merch_name", "merchandise_category_id", "price", "stock_quantity", "updated_at" ]
  end
end
