Rails.application.routes.draw do
  devise_for :users
  root to: 'books#index'

  resources :users, only: %i[show]

  resources :books, only: %i[index, create] do
    collection do
      get 'search'
      get 'fetch'
    end
  end
end
