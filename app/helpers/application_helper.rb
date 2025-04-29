module ApplicationHelper
  def product_key(product_id, product_type)
    "#{product_type}-#{product_id}"
  end
  def breadcrumbs
    path_segments = request.path.split("/").reject(&:empty?)
    breadcrumbs = [ link_to("Home", root_path) ]
    depth = 0

    if path_segments.first == "products"
      breadcrumbs << link_to("Products", products_path)
      depth = 1

      if path_segments.second == "books"
        breadcrumbs << link_to("Books", products_books_path)
        depth = 2
        if path_segments.third.present?
          if (book = Book.find_by(id: path_segments.third))
            breadcrumbs << link_to(book.title, book_path(book))
            depth = 3
          end
        end
      elsif path_segments.second == "merchandise"
        breadcrumbs << link_to("Merchandise", products_merchandise_path)
        depth = 2
        if path_segments.third.present?
          if (merchandise = Merchandise.find_by(id: path_segments.third))
            breadcrumbs << link_to(merchandise.merch_name, merchandise_path(merchandise))
            depth = 3
          end
        end
      elsif path_segments.second.present? # Direct product view under /products/:id
        if (book = Book.find_by(id: path_segments.second))
          breadcrumbs << link_to(book.title, book_path(book))
          depth = 2
        elsif (merchandise = Merchandise.find_by(id: path_segments.second))
          breadcrumbs << link_to(merchandise.merch_name, merchandise_path(merchandise))
          depth = 2
        end
      end
    elsif path_segments.first == "book"
      breadcrumbs << link_to("Products", products_path)
      breadcrumbs << link_to("Books", products_books_path)
      depth = 2
      if path_segments.second.present?
        if (book = Book.find_by(id: path_segments.second))
          breadcrumbs << link_to(book.title, book_path(book))
          depth = 3
        end
      end
    elsif path_segments.first == "merchandise"
      breadcrumbs << link_to("Products", products_path)
      breadcrumbs << link_to("Merchandise", products_merchandise_path)
      depth = 2
      if path_segments.second.present?
        if (merchandise = Merchandise.find_by(id: path_segments.second))
          breadcrumbs << link_to(merchandise.merch_name, merchandise_path(merchandise))
          depth = 3
        end
      end
    end

    content_tag(:div, breadcrumbs.join(" &raquo; ").html_safe, class: "breadcrumbs")
  end
end
