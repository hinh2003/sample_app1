Rails.application.routes.draw do
  # get "static_pages/home" ,to:"static_pages#home"
  get "/help" , to:"static_pages#help", as:'helf'
  get "/about" , to:"static_pages#about"
  get "/contact" , to:"static_pages#contact"
  get "/signup" , to:"users#new"
  get "/login" , to:"sessions#new"
  post "/login" , to:"sessions#create"
  get "/logout" , to:"sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  root 'static_pages#home'
end
