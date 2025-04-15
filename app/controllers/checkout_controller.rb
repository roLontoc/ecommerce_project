class CheckoutController < ApplicationController
  def checkout
    @cart_items = []
    total_amount = 0

    if session[:cart]
      session[:cart].each do |key, quantity|
        product_id, product_type = split_product_key(key)
        product = find_product(product_id, product_type)
        if product
          @cart_items << { product: product, quantity: quantity, product_type: product_type }
          total_amount += product.price * quantity
        end
      end
    end

    if @cart_items.empty?
      redirect_to show_cart_path, alert: "Your cart is empty. Cannot proceed to checkout."
      return
    end
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      mode: "payment",
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      line_items: @cart_items.map do |item|
        {
          price_data: {
            currency: "cad", # Adjust currency as needed
            unit_amount: (item[:product].price * 100).to_i,
            product_data: {
              name: item[:product].respond_to?(:title) ? item[:product].title : item[:product].name,
              description: item[:product].respond_to?(:description) ? item[:product].description : item[:product].details
            }
          },
          quantity: item[:quantity]
        }
      end
    )
    redirect_to session.url, allow_other_host: true
  end

  def success
    session[:cart] = {}
    flash[:notice] = "Payment successful! Thank you for your order."
    redirect_to root_path
  end

  def cancel
    flash[:alert] = "Payment was cancelled."
    redirect_to show_cart_path
  end

  def split_product_key(key)
    key.split("-")
  end

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
