Rails.application.routes.draw do
  devise_for :users
  root to: 'books#index'

  resources :books, only: %i[index] do
    collection do
      get 'search'
    end
  end
end
