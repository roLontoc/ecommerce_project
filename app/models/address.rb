class Address < ApplicationRecord
  belongs_to :province, optional: true
  belongs_to :customer, optional: true
  validates :street, :city, :province, :postal_code, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "city", "created_at", "customer_id", "id", "id_value", "postal_code", "province_id", "street", "updated_at" ]
  end
end
