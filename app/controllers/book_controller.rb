class BookController < ApplicationController
  def index
    @book = Book.all
  end
  def show
    @book = Book.find(params[:id])
  end
end
