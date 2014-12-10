class BooksController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]
  layout 'admin', except: [:index, :show]

  def index
    @books = Book.approved.with_cover
  end

  def admin_index
    @published = Book.approved
    @pending = Book.pending
  end

  def new
    @book = Book.new
  end

  def create
    # assign file to new book
    # book_content = BookContentUploader.new
    # book_content.store!(params[:book][:file])

    # params[:book][:content_text] = book_content
    author = Author.find_or_create_by(full_name: params[:book][:author])
    params[:book][:author_id] = author.id
    book = Book.create(book_params)
    if book.save
      flash[:notice] = "Successfully created new book."
      redirect_to admin_index_books_path
    else
      flash[:alert] = "Could not create book."
      render :new
    end
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

  def destroy
    book = Book.find(params[:id])
    author = book.author
    if book.destroy
      author.destroy unless author.books.any?
      flash[:notice] = "Successfully deleted."
    else
      flash[:alert] = "Could not delete."
    end
    redirect_to admin_index_books_path
  end

  def cover_chooser
    @book = Book.find(params[:id])
    search_term = "#{@book.title},#{@book.author.full_name}"
    response_group = {:response_group => 'ItemAttributes,Images'}
    @products = []
    res = Amazon::Ecs.item_search(search_term, response_group)
    res.items.each do |item|
      product = OpenStruct.new
      product.title = item.get('ItemAttributes/Title')
      product.url = item.get('DetailPageURL')
      product.image_url = item.get('LargeImage/URL')

      @products << product
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :author_id, :content_text)
  end

end
