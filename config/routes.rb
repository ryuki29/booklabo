Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  
  root to: 'users#index'
  resources :users, only: %i[index show update] do
    collection do
      get 'test'
      get 'privacy'
    end
  end

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
