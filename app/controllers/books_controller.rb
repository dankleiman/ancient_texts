class BooksController < ApplicationController
  before_action :authenticate_admin!, only: [:edit, :update]

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
      'Keywords'=> @book.title,
      'ResponseGroup' => "ItemAttributes,Images"
    }

    raw_products = request.item_search(query: params)
    hashed_products = raw_products.to_h
    @products = hashed_products['ItemSearchResponse']['Items']['Item'].map { |item| item['LargeImage']['URL'] }
      # product = OpenStruct.new
      # product = item['ItemAttributes']['Title']
      # product.name = item['ItemAttributes']['Title']
      # product.url = item['DetailPageURL']

    render :layout => 'admin'
  end

  private

  def book_params
    params.require(:book).permit(:title, :content)
  end

end
