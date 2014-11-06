Rails.application.routes.draw do
  devise_for :users
  resources :books, only: [:index, :show, :edit, :update]
  resources :blog_posts do
    collection do
      get :approval_queue
    end
  end
  resources :blog_posts
  resources :users do
    collection do
      post :subscribe
    end
  end

  root to: "blog_posts#index"
end
