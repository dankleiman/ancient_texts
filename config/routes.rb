Rails.application.routes.draw do
  devise_for :users
  resources :books, only: [:index, :show, :edit, :update]

  root to: "books#index"
end
