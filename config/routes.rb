Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  root to: 'books#index'

  resources :users, only: %i[show update]
  resources :relationships, only: %i[create destroy] do
    member do
      get 'followers'
      get 'following'      
    end
  end

  resources :books, only: %i[create destroy] do
    collection do
      get 'search'
    end

    member do
      get 'review', to: 'reviews#show'
      put 'review', to: 'reviews#update'
    end
  end
end
