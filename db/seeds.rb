require 'httparty'
require 'uri'
require 'faker'
require "csv"

OrderItem.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'order_items'")

Order.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'orders'")

Address.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'addresses'")

Customer.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'customers'")

Merchandise.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'merchandises'")

MerchandiseCategory.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'merchandise_categories'")

BookGenreAssignment.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'book_genre_assignments'")

Book.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'books'")

BookGenre.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'book_genres'")

Author.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'authors'")

Province.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'provinces'")

def search_author(query)
  encoded_query = URI.encode_www_form_component(query)
  response = HTTParty.get("https://openlibrary.org/search/authors.json?q=#{encoded_query}")
  if response.success?
    response['docs']&.first
  else
    puts "Error searching for author: #{response.message}"
    nil
  end
end

def fetch_author_details(author_key)
  response = HTTParty.get("https://openlibrary.org/authors/#{author_key}.json")
  if response.success?
    response.parsed_response
  else
    puts "Error fetching author details: #{response.message}"
    nil
  end
end

def fetch_book_data(query)
  encoded_query = URI.encode_www_form_component(query)
  response = HTTParty.get("https://openlibrary.org/search.json?q=#{encoded_query}")
  if response.success?
    response['docs']&.first
  else
    puts "Error fetching book data: #{response.message}"
    nil
  end
end

def fetch_work_data(work_id)
  response = HTTParty.get("https://openlibrary.org/works/#{work_id}.json")
  if response.success?
    response.parsed_response
  else
    puts "Error fetching work data: #{response.message}"
    nil
  end
end

# Seed Books, Authors, and Genres
50.times do |i|
  book_data = fetch_book_data(Faker::Book.title)

  if book_data
    work_id = book_data['key'].gsub('/works/', '')
    work_details = fetch_work_data(work_id)

    if work_details

      author_data = search_author(book_data['author_name']&.first || "Unknown Author")

      if author_data
        author_key = author_data['key'].gsub('/authors/', '')
        author_details = fetch_author_details(author_key)

        if author_details
          author = Author.find_or_create_by(author_name: author_details['name'])

          genres = []
          if work_details['subjects'] && work_details['subjects'].any?
            work_details['subjects'].take(5).each do |subject|
              genres << BookGenre.find_or_create_by(genre_name: subject.downcase.strip).id
            end
          else
            genres << BookGenre.find_or_create_by(genre_name: 'Fiction').id
          end

          # Create Book
          book = Book.create(
            title: work_details['title'],
            description: work_details['description']&.[]('value') || 'No description available.',
            price: Faker::Number.decimal(l_digits: 2),
            stock_quantity: rand(1..100),
            author_id: author.id,
            book_genre_id: genres.first
          )

          # Associate Additional Genres
          genres.drop(1).each do |genre_id|
            book.book_genres << BookGenre.find(genre_id)
          end

          puts "Created book #{i + 1}: #{book.title}"
        else
          puts "Could not fetch author details for key: #{author_key}"
        end
      else
        puts "Could not find author for: #{book_data['author_name']&.first || 'Unknown Author'}"
      end
    else
      puts "Could not fetch details for work ID: #{work_id}"
    end
  else
    puts "Could not fetch book."
  end
end

puts "Books, Authors, and Genres populated."

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Province.create(name: "Alberta", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "British Columbia", pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "Manitoba", pst_rate: 0.07, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "New Brunswick", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
Province.create(name: "Newfoundland and Labrador", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
Province.create(name: "Nova Scotia", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
Province.create(name: "Ontario", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.13)
Province.create(name: "Prince Edward Island", pst_rate: 0.0, gst_rate: 0.0, hst_rate: 0.15)
Province.create(name: "Quebec", pst_rate: 0.09975, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "Saskatchewan", pst_rate: 0.06, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "Northwest Territories", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "Nunavut", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)
Province.create(name: "Yukon", pst_rate: 0.0, gst_rate: 0.05, hst_rate: 0.0)

merchandiseCategoryFile = Rails.root.join('db/merchandise_category.csv')

merchandiseCategoryCSV = File.read(merchandiseCategoryFile)

merchandiseCategories = CSV.parse(merchandiseCategoryCSV, headers: true)

merchandiseCategories.each do |merchandiseCategory |
  new_merchandiseCategory = MerchandiseCategory.create(
    category_name: merchandiseCategory["merch_category"]
  )
end

def generate_fake_merch(num_items = 5)
  num_items.times do |i|
    category = MerchandiseCategory.order('RANDOM()').first
    category_id = category.id
    category_name = category.category_name

    merch_name = case category_name
    when "Apparel"
      "#{Faker::Adjective.positive.capitalize} #{%w[Tshirt Sweatshirt Hat].sample}"
    when "Reading Accessories"
      "#{Faker::Adjective.positive.capitalize} #{%w[Bookmark Book\ Sleeve Mug 'Tote\ Bag Book\ Light].sample}"
    when "Home Décor"
      "#{Faker::Adjective.positive.capitalize} #{%w[Poster Candle 'Throw\ Pillow Wall\ Tapestry].sample}"
    when "Stationary"
      "#{Faker::Adjective.positive.capitalize} #{%w[Notebook 'Pen\ Set Sticky\ Notes 'Washi\ Tape].sample}"
    end
    description = " #{[ 'Perfect for book lovers.', 'Enhance your reading experience.', 'Add a touch of literary charm.', 'Perfect for writing down your thoughts.' ].sample}"

    price = Faker::Commerce.price(range: 8.99..59.99)
    stock_quantity = Faker::Number.between(from: 10, to: 150)

    Merchandise.create!(
      merch_name: merch_name,
      description: description,
      price: price,
      stock_quantity: stock_quantity,
      merchandise_category_id: category_id
    )
  end
end

generate_fake_merch(50)
puts "Merchandise populated!"


puts "Creating Customers..."
20.times do
  Customer.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email
  )
end
puts "Customers created."

  # Create Orders
  puts "Creating Orders..."
  Customer.all.each do |customer|
    rand(1..3).times do
    order_date = Faker::Date.between(from: 1.year.ago, to: Date.today)
    order_total = 0.0
    order_tax = 0.0

    order = Order.create!(
      customer: customer,
      order_date: order_date,
      order_total: order_total,
      order_tax: order_tax
    )

    # Create Order Items for each order
    rand(1..5).times do # Each order has 1 to 5 items
      if rand(2) == 0 # 50% chance of being a book
        book = Book.order('RANDOM()').first # Get a random book
        quantity = rand(1..3)
        price_at_order = book.price

        OrderItem.create!(
          order: order,
          book_id: book.id,  # Use book_id
          quantity: quantity,
          price_at_order: price_at_order
        )
        order_total += quantity * price_at_order  # Update order_total
      else # 50% chance of being merchandise
        merch = Merchandise.order('RANDOM()').first # Get a random merch item
        quantity = rand(1..3)
        price_at_order = merch.price

        OrderItem.create!(
          order: order,
          merchandise_id: merch.id, # Use merch_id
          quantity: quantity,
          price_at_order: price_at_order
        )
        order_total += quantity * price_at_order # Update order_total
      end
    end

    order_tax = order_total * 0.12 # Calculate 12% sales tax
    order_total += order_tax       # Add sales tax to the order total

    order.update!(
      order_total: order_total.round(2),
      order_tax: order_tax.round(2)
    )
    puts "Order Items created for Order #{order.id}."
  end
end
puts "Orders created."
