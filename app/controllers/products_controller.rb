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

  def filter_books_by_author
      @products = Book.joins(:author).where("authors.author_name = ?", params[:author_name]).page(params[:page]).per(10)
      render "index"
  end

  def filter_merchandise_by_category
      @products = Merchandise.joins(:merchandise_category).where("merchandise_categories.category_name = ?", params[:merchandise_category_name]).page(params[:page]).per(10)
      render "index"
  end
end
