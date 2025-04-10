module ApplicationHelper
  def product_key(product_id, product_type)
    "#{product_type}-#{product_id}"
  end
end
