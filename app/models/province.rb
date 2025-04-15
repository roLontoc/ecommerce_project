class Province < ApplicationRecord
  has_many :customers
  has_many :addresses
end
