class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @sections = @book.sections.paginate(:page => params[:page])
  end

end
