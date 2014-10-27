class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @sections = @book.sections.order(:position).paginate(:page => params[:page])
  end

end
