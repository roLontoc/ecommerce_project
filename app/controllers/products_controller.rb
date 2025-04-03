class ProductsController < ApplicationController
  def index
    @products = (Book.all + Merchandise.all).shuffle
    @products = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end
end
