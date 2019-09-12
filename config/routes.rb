Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  root to: 'books#index'

  resources :users, only: %i[show]

  resources :books, only: %i[create destroy] do
    collection do
      get 'search'
      get 'fetch'
    end

    member do
      get 'review', to: 'reviews#show'
      put 'review', to: 'reviews#update'
    end
  end
end
