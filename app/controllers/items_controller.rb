class ItemsController < ApplicationController

  def create
    book = Book.find(params[:item][:book_id])
    if book.item.present?
      item = book.item
      item.update_attributes(item_params)
    else
      item = Item.new(item_params)
    end
    if item.save
      flash[:notice] = "Successfully created."
      redirect_to admin_index_books_path
    else
      flash[:alert] = "Could not create item."
      redirect_to cover_chooser_book_path(params[:item][:book_id])
    end
  end

  private

  def item_params
    params.require(:item).permit(:title, :detail_page_url, :image_url, :book_id)
  end
end
