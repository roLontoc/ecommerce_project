require 'httparty'
require 'uri'
require 'faker'

Book.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'books'")

BookGenre.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'book_genres'")

Author.delete_all
ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name = 'authors'")



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
10.times do |i|
  book_data = fetch_book_data(Faker::Book.title)

  if book_data
    work_id = book_data['key'].gsub('/works/', '')
    work_details = fetch_work_data(work_id)

    if work_details
      # Find Author
      author_data = search_author(book_data['author_name']&.first || "Unknown Author")

      if author_data
        author_key = author_data['key'].gsub('/authors/', '')
        author_details = fetch_author_details(author_key)

        if author_details
          author = Author.find_or_create_by(author_name: author_details['name'])

          # Create Genres (up to 5 subjects)
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
