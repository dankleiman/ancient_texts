Rails.application.routes.draw do
  resources :books, only: :show
end
