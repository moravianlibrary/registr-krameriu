Rails.application.routes.draw do


  root to: 'libraries#index'

  resources :libraries do
    member do
      get "logo"
      get "thumb"
      get "history"
    end
  end
  resources :sessions, only: [:new, :create, :destroy]


  get '/login' => 'sessions#new', as: "login"
  get '/logout' => 'sessions#destroy', as: "logout"

  get 'feeder/' => 'feeder#all'
  get 'feeder/reset_clients' => 'feeder#reset_clients'
  get 'feeder/:code' => 'feeder#library'
  get 'ping/' => 'feeder#ping'


  get 'analytics/increments' => 'analytics#increments'
  get 'analytics/data' => 'analytics#data'

end
