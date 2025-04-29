Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :customers, controllers: {
  sessions: "customers/sessions",
  registrations: "customers/registrations"
}
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
  get "provinces/:id/tax_rates", to: "provinces#tax_rates"
  get "invoice/:order_number", to: "checkout#invoice", as: "invoice_checkout"


  resources :orders, only: [ :show ]

  resource :customer, only: [ :show, :edit, :update ] do
    get "order_history", to: "customers#order_history"
  end

  resources :products, only: [ :index ] do
    collection do
      post "add_to_cart"
      get "show_cart"
      delete "remove_from_cart"
      patch "update_cart_quantity"
    end
  end
  scope "/checkout" do
    get "shipping_information", to: "checkout#shipping_information", as: "checkout_shipping_information"
    post "create", to: "checkout#create", as: "checkout_create"
    post "payment", to: "checkout#payment", as: "checkout_payment"
    get "success", to: "checkout#success", as: "checkout_success"
    get "cancel", to: "checkout#cancel", as: "checkout_cancel"
    post "update_address", to: "checkout#update_address", as: "checkout_update_address"
  end

  get "up" => "rails/health#show", as: :rails_health_check

  resources :orders, only: [ :show ]
  resources :book
  resources :merchandise
  resources :authors
  resources :merchandise_categories
end
