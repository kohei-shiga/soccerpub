Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  root to: 'articles#index'
 
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update] do
    member do
      get :followings
      get :followers
      get :favorite_articles
    end
  end
  
  resources :articles, only: [:show, :new, :create, :destroy] do
    collection do
      get :timeline
      get :favorite_articles
    end
  end
  
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

end
