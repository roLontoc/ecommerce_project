ActiveAdmin.register Merchandise do
  permit_params :merch_name, :description, :price, :stock_quantity, :merchandise_category_id, :image

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
