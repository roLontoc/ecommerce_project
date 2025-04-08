ActiveAdmin.register Book do
  permit_params :title, :description, :price, :stock_quantity, :author_id, :book_genre_id, :image

  remove_filter :image_attachment, :image_blob

  form do |f|
    f.semantic_errors
    f.inputs
    f.inputs do
      f.input :image, as: :file
    end
    f.actions
  end
end
