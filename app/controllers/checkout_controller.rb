class CheckoutController < ApplicationController
  before_action :authenticate_customer!

  # Displays the shipping information form and cart details
  def shipping_information
    @customer = current_customer
    @customer.build_address if @customer.address.nil?
    @cart_items = get_cart_items
    @provinces = Province.all

    @subtotal = calculate_subtotal(@cart_items)

    if @customer.address&.province_id
      @province = Province.find(@customer.address.province_id)
    else
      @province = nil
    end

    @tax = calculate_tax_amount(@subtotal, @province)
    @total = @subtotal + @tax
  end

  def update_address
    @customer = current_customer

    if @customer.address.nil?
      @customer.build_address(customer_params[:address_attributes])
    else
      @customer.address.update(customer_params[:address_attributes])
    end

    if @customer.save
      flash[:notice] = "Address updated successfully!"
      redirect_to checkout_shipping_information_path
    else
      flash[:alert] = "Failed to update address."
      redirect_to checkout_shipping_information_path
    end
  end
  def create
    # Processes the shipping information update
    @customer = current_customer

    # If the customer does not have an address, build one
    if @customer.address.nil?
      @customer.build_address(customer_params[:address_attributes])
    else
      @customer.address.update(customer_params[:address_attributes])
    end

    # Ensure the customer_id is set for the address
    if @customer.address.present?
      @customer.address.customer_id = @customer.id
    end

    # Now attempt to save the customer with the address
    if @customer.save
      flash[:notice] = "Shipping information updated successfully!"

      # Calculate the cart items and total
      @cart_items = get_cart_items
      @subtotal = calculate_subtotal(@cart_items)

      # Find the province based on the selected province_id
      if @customer.address.province_id
        @province = Province.find(@customer.address.province_id)
      else
        @province = nil
      end

      # Calculate the tax and total based on the province
      @tax = calculate_tax_amount(@subtotal, @province)
      @total = @subtotal + @tax

      # Redirect to the payment page or proceed to the next step
      redirect_to checkout_payment_path
    else
      flash[:alert] = "There was an error updating your shipping information."
      render :shipping_information
    end
  end
  # Displays the payment processing page
  def payment
    @cart_items = get_cart_items
    if @cart_items.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to products_path
      return
    end

    @customer = current_customer
    @customer.reload # Crucial: Get the latest address from the database
    @province = Province.find_by(id: @customer.address&.province_id)

    # province_id = params.dig(:customer, :address_attributes, :province_id)
    # province = Province.find_by(id: province_id)

    subtotal_amount = calculate_subtotal(@cart_items)
    tax_amount = calculate_tax_amount(subtotal_amount, @province)
    @total_amount = subtotal_amount + tax_amount

    tax_rate = 0.0
   if @province
     tax_rate = (@province.gst_rate || 0.0) + (@province.pst_rate || 0.0) + (@province.hst_rate || 0.0)
   else
     tax_rate = 0.05 # Default GST
   end

   line_items = create_line_items(@cart_items, @total_amount, tax_rate)

    if @session.nil?
      @session = Stripe::Checkout::Session.create(
        payment_method_types: [ "card" ],
        success_url: checkout_success_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: checkout_cancel_url,
        mode: "payment",
        line_items: line_items,
        metadata: {
          user_id: current_customer.id,
          total_amount: @total_amount,
          subtotal_amount: subtotal_amount,
          tax_amount: tax_amount
        }
      )
      session[:stripe_checkout_session_id] = @session.id
    end

    redirect_to @session.url, allow_other_host: true
  end
  # Handles successful payment
  def success
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    order = Order.create!(
      customer_id: current_customer.id,
      order_total: session.metadata.total_amount.to_f,
      order_tax: session.metadata.tax_amount.to_f,
      order_number: params[:session_id],
      status: "paid",
      order_date: Date.today
    )

    # create order items
    cart_items = get_cart_items
    cart_items.each do |item|
      book = nil
      merchandise = nil

      if item[:product].is_a?(Book)
        book = item[:product]
      elsif item[:product].is_a?(Merchandise)
        merchandise = item[:product]
      end

      if book.nil? && merchandise.nil?
        flash[:alert] = "Product not found for cart item."
        redirect_to checkout_shipping_information_path
        return
      end
      OrderItem.create!(
        order_id: order.id,
        book_id: book&.id,          # Set book_id if it's a book
        merchandise_id: merchandise&.id,  # Set merchandise_id if it's merchandise
        quantity: item[:quantity],
        price_at_order: item[:product].price,
      )
    end

    clear_cart # clear cart
    session[:stripe_checkout_session_id] = nil # Clear Stripe session ID
    flash[:notice] = "Payment was successful. Thank you for your order!"
    redirect_to products_path # Or order confirmation page
  end

  # Handles canceled payment
  def cancel
    flash[:alert] = "Payment was canceled."
    redirect_to show_cart_products_path
  end

  private


  def customer_params
    params.require(:customer).permit(
      :customer_id,
      :first_name,
      :last_name,
      address_attributes: [ :street, :city, :province_id, :postal_code ]
    )
  end

  # Calculate subtotal
  def calculate_subtotal(cart_items)
    cart_items.sum { |item| item[:product].price * item[:quantity] }
  end

  # calculate tax amount
  def calculate_tax_amount(subtotal, province)
    if province
      gst_rate = province.gst_rate || 0.0
      pst_rate = province.pst_rate || 0.0
      hst_rate = province.hst_rate || 0.0
    else
      gst_rate = 0.05 # Default GST if province not found
      pst_rate = 0.0
      hst_rate = 0.0
    end
    tax_rate = gst_rate + pst_rate + hst_rate
    subtotal * tax_rate
  end

  def get_cart_items
    cart_items = []
    if session[:cart]
      session[:cart].each do |key, quantity|
        product_type, product_id = split_product_key(key)
        product = find_product(product_id, product_type)
        if product
          cart_items << { product: product, quantity: quantity, product_type: product_type.capitalize }
        end
      end
    end
    cart_items
  end

  def clear_cart
    session[:cart] = nil
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

  # This method is no longer directly used for updating the Address
  # def customer_params
  #   params.require(:customer).permit(:address, :city, :province, :postal_code)
  # end

  def create_line_items(cart_items, total_amount, tax_rate)
    line_items = cart_items.map do |item|
      {
        price_data: {
          currency: "cad",
          product_data: {
            name: item[:product].respond_to?(:title) ? item[:product].title : item[:product].merch_name

          },
          unit_amount: (item[:product].price * 100 * (tax_rate + 1)).to_i # Price in cents
        },
        quantity: item[:quantity]
      }
    end
  end
end
