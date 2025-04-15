class Address < ApplicationRecord
  belongs_to :province, optional: true
  belongs_to :customer, optional: true
  validates :street, :city, :province, :postal_code, presence: true
end
