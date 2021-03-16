Rails.application.routes.draw do
  root to: 'articles#index'
  
  get 'auth/:provider/callback', to: 'sessions#omniauth'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
    
  get 'signup', to: 'users#new'
  resources :users, param: :friendly_id, only: %i[show create edit update destroy] do
    member do
      get :followings
      get :followers
      get :favorite_articles
      get :introduction
    end
  end
  namespace :admin do
    resources :users, only: %i[index destroy]
    resources :articles, only: [:destroy] do
      collection do
        get :spams
      end
    end 
  end
  
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  
  resources :articles, only: %i[show new create destroy] do
    collection do
      get :timeline
      get :favorite_articles
      get :tagged_articles
    end

    resources :comments, only: [:create]
  end
  
  resources :relationships, only: %i[create destroy]
  resources :favorites, only: %i[create destroy]
  resources :tags, only: [:show]
  resources :tag_follows, only: %i[create destroy]
  resources :searches, only: [:index]
  resources :report_spams, only: %i[create destroy]
  resources :oembed, only: [:create]
end
