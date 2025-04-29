class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  before_create :generate_order_number

  validates :order_total, :order_tax, numericality: true
  validates :order_date, :order_tax, :order_total, :order_number, :status, presence: true
  validates :customer, presence: true

  def self.ransackable_associations(auth_object = nil)
    [ "customer", "order_items" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "customer_id", "id", "id_value", "order_date", "order_number", "order_tax", "order_total", "status", "updated_at" ]
  end


  private

  def generate_order_number
    self.order_number = SecureRandom.hex(8)
  end
end
