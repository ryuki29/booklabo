Rails.application.routes.draw do
  root to: 'books#index'

  resources :books, only: %i[index] do
    collection do
      get 'search'
    end
  end
end
