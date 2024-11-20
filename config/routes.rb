Rails.application.routes.draw do
  get 'users/new'
  # get "static_pages/home" ,to:"static_pages#home"
  get "/help" , to:"static_pages#help", as:'helf'
  get "/about" , to:"static_pages#about"
  get "/contact" , to:"static_pages#contact"
  get "/signup" , to:"users#new"


  # get 'static_pages/help'
  # get 'static_pages/about'
  # get 'static_pages/contact'
  # get 'static_pages/home'
  root 'static_pages#home'
end
