class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :get_random_books

  def get_random_books
    @random_books = Book.with_cover.sample(6)
  end

  def authenticate_admin!
    if !current_user or current_user.role != 'admin'
      flash[:alert] = 'You are not authorized to view this page.'
      redirect_to root_url
    end
  end
end
