# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
  def create
    super do |customer|
      flash[:notice] = "Welcome back, #{customer.first_name}!"
    end
end
end
