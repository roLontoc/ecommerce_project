class CheckoutController < ApplicationController
  before_action :find_cart_items, only: [ :checkout, :create, :success ]
  def checkout
    if @cart_items.empty?
      redirect_to show_cart_products_path, alert: "Your cart is empty. Cannot proceed to checkout."
      nil
    end

    if customer_signed_in?
      @customer = current_customer
      @address = current_customer.address.present? ? current_customer.address : Address.new
    else
      @address = Address.new
      @customer = nil
    end
  end
  def create
    if @cart_items.empty?
      redirect_to show_cart_products_path, alert: "Your cart is empty. Cannot proceed."
      nil
    end

    if customer_signed_in?
      @customer = current_customer
      if current_customer.address.present?
        @address = current_customer.address
      else
        @address = Address.new(address_params)
        unless @address.save
          flash.now[:alert] = "Please provide a valid address."
          render :checkout and return
        end
        current_customer.update(address: @address)
        current_customer.update(province: @address.province) # Set customer's province
      end
    else
      @address = Address.new(address_params)
      unless @address.save
        flash.now[:alert] = "Please provide a valid address."
        render :checkout and return
      end
      @customer = nil
    end
    total_amount = calculate_total_with_taxes(@cart_items, @address.province)
    @order = Order.new(customer: @customer, total_amount: total_amount)

    if @order.save
      @cart_items.each do |item|
        OrderItem.create(
          order: @order,
          product: item[:product],
          quantity: item[:quantity],
          price: item[:product].price
        )
      end
      stripe_session = Stripe::Checkout::Session.create(
        payment_method_types: [ "card" ],
        mode: "payment",
        success_url: checkout_success_url(order_number: @order.order_number),
        cancel_url: checkout_cancel_url,
        line_items: @cart_items.map do |item|
          {
            price_data: {
              currency: "cad",
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
      session[:order_number] = @order.order_number
      session[:cart] = {}
      redirect_to stripe_session.url, allow_other_host: true
    else
      flash.now[:alert] = "There was an error processing your order."
      render :checkout
    end
  end
  def success
    @order = Order.find_by(order_number: params[:order_number])
    if customer_signed_in?
      current_customer.associate_cart_with_customer(session[:cart]) if session[:cart]
      session[:cart] = {}
    end
    flash[:notice] = "Payment successful! Thank you for your order."
    redirect_to order_path(@order) if defined? order_path
    redirect_to root_path
  end

  def cancel
    flash[:alert] = "Payment was cancelled."
    redirect_to show_cart_products_path
  end

  private

  def address_params
    params.require(:address).permit(:street, :city, :province_id, :postal_code) # province_id
  end

  def find_cart_items
    @cart_items = []
    if session[:cart]
      session[:cart].each do |key, quantity|
        product_id, product_type = split_product_key(key)
        product = find_product(product_id, product_type)
        if product
          @cart_items << { product: product, quantity: quantity, product_type: product_type }
        end
      end
    end
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

  def calculate_total_with_taxes(cart_items, province)
    subtotal = cart_items.sum { |item| item[:product].price * item[:quantity] }
    pst_rate, gst_rate, hst_rate = get_tax_rates(province)
    pst = subtotal * pst_rate
    gst = subtotal * gst_rate
    hst = subtotal * hst_rate
    subtotal + pst + gst + hst
  end

  def get_tax_rates(province)
    if province.is_a?(Province)
      [ province.pst_rate, province.gst_rate, province.hst_rate ]
    else
      province_record = Province.find(province)
      [ province_record.pst_rate, province_record.gst_rate, province_record.hst_rate ]
    end
  end
end
