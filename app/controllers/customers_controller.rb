class CustomersController < ApplicationController
  before_action :authenticate_customer!

  def order_history
    @orders = current_customer.orders.order(created_at: :desc)
  end
end
