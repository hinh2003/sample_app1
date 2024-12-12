# frozen_string_literal: true

Rails.application.routes.draw do
  get '/help', to: 'static_pages#help', as: 'helf'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'

  get '/auth/:provider/callback', to: 'sessions#create_third_party'

  post '/microposts/reactions', to: 'reactions#create', as: 'reactions'
  delete '/microposts/:micropost_id/reactions', to: 'reactions#destroy', as: 'destroy_reaction'
  resources :messages
  resources :rooms
  get 'rooms/user/:recipient_id', to: 'rooms#create_room', as: 'create_room_user'
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
