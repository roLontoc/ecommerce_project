Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "pages#home"
  get "/about", to: "pages#about", as: "about"
  get "/contact", to: "pages#contact", as: "contact"
  get "/products/search", to: "products#search", as: "search_products"

  get "/products", to: "products#index", as: "products"
  get "/products/books", to: "products#books_only", as: "products_books"
  get "/products/merchandise", to: "products#merchandise_only", as: "products_merchandise"
  get "/products/books/author/:author_name", to: "products#filter_books_by_author", as: :products_books_by_author
  get "/products/merchandise/category/:merchandise_category_name", to: "products#filter_merchandise_by_category", as: :products_merchandise_by_category

  resources :products, only: [ :index ] do
    collection do
      post "add_to_cart"
      get "show_cart"
      delete "remove_from_cart"
      patch "update_cart_quantity"
    end
  end
  scope "/checkout" do
    post "create", to: "checkout#create", as: "checkout_create"
    post "success", to: "checkout#success", as: "checkout_success"
    post "cancel", to: "checkout#cancel", as: "checkout_cancel"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  resources :book
  resources :merchandise
  resources :authors
  resources :merchandise_categories
end
