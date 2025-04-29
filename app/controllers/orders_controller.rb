class OrdersController < ApplicationController
  before_action :authenticate_customer!
  before_action :set_order, only: [ :show ]

  def show
    @order_items = @order.order_items
  end

  private

  def set_order
    @order = current_customer.orders.find(params[:id])
    # Ensure the customer can only view their own orders
    unless @order
      redirect_to customer_order_history_path, alert: "Order not found."
    end
  end
end
