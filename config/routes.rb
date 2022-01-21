# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players, only: [:index, :show]
  get '/' => 'players#root'
end
