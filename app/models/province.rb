class Province < ApplicationRecord
  has_many :customers
  has_many :addresses

  validates :name, presence: true
  validates :pst_rate, :gst_rate, :hst_rate, numericality: true


  def self.ransackable_associations(auth_object = nil)
    [ "addresses", "customers" ]
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "gst_rate", "hst_rate", "id", "id_value", "name", "pst_rate", "updated_at" ]
  end
end
