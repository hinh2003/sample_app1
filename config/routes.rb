# frozen_string_literal: true

Rails.application.routes.draw do
  # get "static_pages/home" ,to:"static_pages#home"
  get '/help', to: 'static_pages#help', as: 'helf'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'

  get '/auth/:provider/callback', to: 'sessions#create_third_party'
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: %i[new create edit update]
  resources :microposts, only: %i[create destroy update edit show]

  resources :relationships, only: %i[create destroy]

  root 'static_pages#home'
end
