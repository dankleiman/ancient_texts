Rails.application.routes.draw do
  devise_for :users
  resources :authors, only: :index
  resources :books do
    member do
      get :cover_chooser
    end
  end
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

  get "sitemap.xml" => "home#sitemap", format: :xml, as: :sitemap
  get "robots.txt" => "home#robots", format: :text, as: :robots
  get "/privacy" => "home#privacy", format: :html, as: :privacy

  root to: "blog_posts#index"
end
