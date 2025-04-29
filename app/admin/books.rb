ActiveAdmin.register Book do
  permit_params :title, :description, :price, :stock_quantity, :author_id, :book_genre_id, :image, book_genre_assignments_attributes: [ :id, :book_id, :book_genre_id, :_destroy ]

  remove_filter :image_attachment, :image_blob

  index do
    selectable_column
    column :id
    column :title
    column :description
    column :price
    column :stock_quantity
    column :author
    column :book_genres do |book|
      book.book_genres.map { |b| b.genre_name }. join(", ").html_safe
    end
  end

  show do |book|
    attributes_table do
      row :title
      row :description
      row :price
      row :stock_quantity
      row :author
      row :book_genres do |book|
        book.book_genres.map { |b| b.genre_name }.join(", ").html_safe
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Book" do
      f.input :title
      f.input :description
      f.input :price
      f.inputs :stock_quantity
      f.inputs :author
      f.has_many :book_genre_assignments, allow_destroy: true do |n_f|
        n_f.input :book_genre
      end
    f.inputs do
      f.input :image, as: :file
    end
    f.actions
  end
end
end
