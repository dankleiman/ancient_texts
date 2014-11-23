class BooksController < ApplicationController
  before_action :authenticate_admin!, except: [:index, :show]

  def index
    @books = Book.approved.with_cover
  end

  def admin_index
    @published = Book.approved
    @pending = Book.pending
    render :layout => 'admin'
  end

  def new
    @book = Book.new

    render :layout => 'admin'
  end

  def create
    Book.create_from_txt!(params[:book][:file])
    flash[:notice] = "Successfully created new book."
    redirect_to admin_index_books_path
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
    if book.destroy
      flash[:notice] = "Successfully deleted."
    else
      flash[:alert] = "Could not delete."
    end
    redirect_to admin_index_books_path
  end

  def cover_chooser
    @book = Book.find(params[:id])
    request = Vacuum.new

    request.configure(
      aws_access_key_id: ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      associate_tag: ENV['ASSOCIATE_TAG']
      )
    params = {
      'SearchIndex' => 'Books',
      'Keywords'=> "#{@book.title},#{@book.author.full_name}",
      'ResponseGroup' => "ItemAttributes,Images"
    }
    @products = []
    products = request.item_search(query: params).to_h
    products['ItemSearchResponse']['Items']['Item'].each do |item|
      product = OpenStruct.new
      product.title = item['ItemAttributes']['Title']
      product.url = item['DetailPageURL']
      product.image_url = item['LargeImage']['URL']

      @products << product
    end

    render :layout => 'admin'
  end

  private

  def book_params
    params.require(:book).permit(:title, :content, :approved)
  end

end
