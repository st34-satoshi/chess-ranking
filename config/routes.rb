# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players, only: %i[index show]
  get '/all_players' => 'players#index_json'
  get '/' => 'players#root'
end
