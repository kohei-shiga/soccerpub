Rails.application.routes.draw do
  root to: 'users#index'
    
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update]

end
