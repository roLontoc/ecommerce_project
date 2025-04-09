Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "pages#home"
  get "/about", to: "pages#about", as: "about"
  get "/contact", to: "pages#contact", as: "contact"


  get "/products", to: "products#index", as: "products"
  get "/products/books", to: "products#books_only", as: "products_books"
  get "/products/merchandise", to: "products#merchandise_only", as: "products_merchandise"
  get "/products/books/author/:author_name", to: "products#filter_books_by_author", as: :products_books_by_author
  get "/products/merchandise/category/:merchandise_category_name", to: "products#filter_merchandise_by_category", as: :products_merchandise_by_category


  get "up" => "rails/health#show", as: :rails_health_check

  resources :book
  resources :merchandise
  resources :authors
  resources :merchandise_categories
end
