Rails.application.routes.draw do
  get '/index', to: 'home#index'
  get '/hoge', to: 'player#index'

  resources :players #, only: [:index]
end
