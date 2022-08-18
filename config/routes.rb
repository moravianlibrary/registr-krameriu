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
  get 'feeder/:code' => 'feeder#single_library'
  get 'ping/' => 'feeder#ping'
  
  get 'analytics/increments' => 'analytics#increments'
  get 'analytics/data' => 'analytics#data'



  namespace :api, constraints: { format: 'json' }, defaults: { :format => :json } do
    resources :libraries, only: [:index, :show] do
      member do
        get "history"
        get "states" => 'states#library'
      end
    end

  end


end
