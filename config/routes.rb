# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players, only: %i[index show]
  get '/' => 'players#root'
end
