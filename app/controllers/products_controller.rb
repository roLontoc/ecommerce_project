class ProductsController < ApplicationController
  def index
    @products = (Book.order(created_at: :desc) + Merchandise.order(created_at: :desc))
    @products = Kaminari.paginate_array(@products).page(params[:page]).per(10)
  end

  def books_only
    @products = Book.all.page(params[:page]).per(10)
    render "index"
  end

  def merchandise_only
    @products = Merchandise.all.page(params[:page]).per(10)
    render "index"
  end
end
