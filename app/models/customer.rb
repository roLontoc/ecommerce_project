class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :province, optional: true
  has_one :address
  has_many :orders
  has_many :cart_products, through: :carts, source: :product

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
