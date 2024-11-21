Rails.application.routes.draw do
  get 'sessions/new'
  # get "static_pages/home" ,to:"static_pages#home"
  get "/help" , to:"static_pages#help", as:'helf'
  get "/about" , to:"static_pages#about"
  get "/contact" , to:"static_pages#contact"
  get "/signup" , to:"users#new"
  get "/login" , to:"sessions#new"
  post "/login" , to:"sessions#create"
  get "/logout" , to:"sessions#destroy"
  resources :users
  resources :account_activations, only: [:edit]
  root 'static_pages#home'
end
