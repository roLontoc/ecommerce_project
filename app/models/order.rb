class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items
  before_create :generate_order_number

  private

  def generate_order_number
    self.order_number = SecureRandom.hex(8)
  end
end
