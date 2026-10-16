# frozen_string_literal: true

Rails.application.routes.draw do
  get '/rapid' => 'players#rapid', as: :rapid
  resources :players, only: %i[index show]
  resources :players_comparisons, only: %i[index show create]
  get '/all_players' => 'players#index_json'
  get '/' => 'players#root'
  get '/distribution' => 'home#distribution'
  get '/delta' => 'home#delta'
  get '/victory_distance' => 'home#victory_distance'
end
