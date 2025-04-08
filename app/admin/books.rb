ActiveAdmin.register Book do
  permit_params :title, :description, :price, :stock_quantity, :author_id, :book_genre_id
end
