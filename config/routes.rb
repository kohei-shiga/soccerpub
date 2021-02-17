Rails.application.routes.draw do
  root to: 'articles#index'
  
  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  get 'signup', to: 'users#new'
  resources :users, only: [:show, :create, :edit, :update, :destroy] do
    member do
      get :followings
      get :followers
      get :favorite_articles
    end
  end
  namespace :admin do
    resources :users, only: [:index]
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  
  resources :articles, only: [:show, :new, :create, :destroy] do
    collection do
      get :timeline
      get :favorite_articles
      get :tagged_articles
    end
  end
  
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]
  resources :tags, only: [:show]
  resources :tag_follows, only: [:create, :destroy]
  resources :searches, only: [:index]

end
