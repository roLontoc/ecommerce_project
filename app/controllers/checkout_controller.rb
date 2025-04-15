class CheckoutController < ApplicationController
  before_action :find_cart_items, only: [ :checkout, :create, :success ]
  def checkout
    if @cart_items.empty?
      redirect_to show_cart_products_path, alert: "Your cart is empty. Cannot proceed to checkout."
      nil
    end

    if customer_signed_in?
      @address = current_customer.address.present? ? current_customer.address : Address.new
    else
      @address = Address.new
    end
    def create
      if @cart_items.empty?
        redirect_to show_cart_products_path, alert: "Your cart is empty. Cannot proceed."
        nil
      end
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
      end
    else
      @address = Address.new(address_params)
      unless @address.save
        flash.now[:alert] = "Please provide a valid address."
        render :checkout and return
      end
      # For guest checkout, we don't have a customer yet
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
    end
  end
end
