Rails.application.routes.draw do
  devise_for :users
  resources :books, only: [:index, :show, :edit, :update]
  resources :blog_posts
  resources :blog_posts do
    get :approval_queue
  end

  root to: "blog_posts#index"
end
