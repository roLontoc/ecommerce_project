class Address < ApplicationRecord
  belongs_to :province
  belongs_to :customer
end
