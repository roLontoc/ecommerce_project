class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :province, optional: true
  has_one :address
  accepts_nested_attributes_for :address
  has_many :orders
  has_many :cart_products, through: :carts, source: :product

  validates :first_name, :last_name, :email, presence: true

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "email", "encrypted_password", "first_name", "id", "id_value", "last_name", "province_id", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at" ]
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, address_attributes: [ :street, :city, :province_id, :postal_code ])
  end

  def associate_cart_with_customer(session_cart)
    # Associate cart items with this customer's cart
    session_cart.each do |key, quantity|
      product_type, product_id = key.split("-")
      product = find_product(product_id, product_type)
      if product
        cart_product_ids << product.id
      end
    end
    save
  end
  private
  def find_product(product_id, product_type)
    case product_type
    when "book"
      Book.find_by(id: product_id)
    when "merchandise"
      Merchandise.find_by(id: product_id)
    else
      nil
    end
  end
end
