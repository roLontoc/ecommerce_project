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

  def search
    keyword = params[:keyword].to_s.downcase
    selected_categories = params[:categories] || [ "Books", "Merchandise" ]

    @products = []

    if selected_categories.include?("Books")
      @products += Book.where("LOWER(title) LIKE ? OR LOWER(description) LIKE ?", "%#{keyword}%", "%#{keyword}%")
    end

    if selected_categories.include?("Merchandise")
      @products += Merchandise.where("LOWER(merch_name) LIKE ? OR LOWER(description) LIKE ?", "%#{keyword}%", "%#{keyword}%")
    end

    @products = Kaminari.paginate_array(@products).page(params[:page]).per(10)
    if @products.any?
      @search_message = "Search results for '#{keyword}'"
    else
      @search_message = "No search results for '#{keyword}'"
    end

    render :index
  end

  def add_to_cart
    product_id = params[:product_id]
    product_type = params[:product_type] # Will be 'book' or 'merchandise'
    quantity = params[:quantity].to_i || 1

    session[:cart] ||= {}
    session[:cart][product_key(product_id, product_type)] ||= 0
    session[:cart][product_key(product_id, product_type)] += quantity

    product_name = find_product(product_id, product_type).respond_to?(:title) ? find_product(product_id, product_type).title : find_product(product_id, product_type).merch_name
    flash[:notice] = "#{product_name} added to cart!"

    redirect_back fallback_location: products_path
  end

  def show_cart
    @cart_items = []
    if session[:cart]
      session[:cart].each do |key, quantity|
        product_type, product_id = split_product_key(key)
        product = find_product(product_id, product_type)
        if product
          @cart_items << { product: product, quantity: quantity, product_type: product_type }
        end
      end
    end
  end

  def remove_from_cart
    product_key = params[:product_key]
    if session[:cart] && session[:cart].key?(product_key)
      session[:cart].delete(product_key)
      redirect_to show_cart_products_path, notice: "Item removed from cart."
    else
      redirect_to show_cart_products_path, alert: "Item not found in cart."
    end
  end

  def update_cart_quantity
    product_key = params[:product_key]
    quantity = params[:quantity].to_i
    if session[:cart] && session[:cart].key?(product_key)
      session[:cart][product_key] = quantity
      redirect_to show_cart_products_path, notice: "Cart updated."
    else
      redirect_to show_cart_products_path, alert: "Item not found in cart."
    end
  end

  private

  def product_key(product_id, product_type)
    "#{product_type}-#{product_id}"
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
