class BooksController < ApplicationController
  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
    @sections = @book.sections.order(:position).paginate(:page => params[:page])
  end

  def update
    book = Book.find(params[:id])
    book.update_attributes(book_params)
      if book.save
        book.regenerate_sections!
        flash[:notice] = "Successfully updated book."
        redirect_to book_path(book)
      else
        flash[:alert] = "Could not update book."
        render :new
      end
  end

  def edit
    @book = Book.find(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:title, :content)
  end

end
