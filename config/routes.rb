Rails.application.routes.draw do
  devise_for :users
  root to: 'books#index'

  resources :users, only: %i[show]

  resources :books, only: %i[create destroy] do
    collection do
      get 'search'
      get 'fetch'
    end

    member do
      get 'review', to: 'reviews#show'
    end
  end
end
