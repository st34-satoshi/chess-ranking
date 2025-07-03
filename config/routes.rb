# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players, only: %i[index show]
  resources :players_comparisons, only: %i[index show create]
  resources :ranking_differences, only: %i[index]
  get '/all_players' => 'players#index_json'
  get '/' => 'players#root'
  get '/distribution' => 'home#distribution'
  get '/victory_distance' => 'home#victory_distance'
end
