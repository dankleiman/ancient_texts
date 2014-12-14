Rails.application.routes.draw do
  devise_for :users
  resources :authors, only: :index
  resources :items, only: :create
  resources :books do
    member do
      get :cover_chooser
    end
    collection do
      get :admin_index
    end
  end
  resources :books
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
  resources :quiz_questions
  resources :answers

  get "sitemap.xml" => "home#sitemap", format: :xml, as: :sitemap
  get "robots.txt" => "home#robots", format: :text, as: :robots
  get "/privacy" => "home#privacy", format: :html, as: :privacy
  get '/feed' => 'blog_posts#feed', as: :feed

  root to: "blog_posts#index"
end
