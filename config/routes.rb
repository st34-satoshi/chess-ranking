# frozen_string_literal: true

Rails.application.routes.draw do
  resources :players # , only: [:index]
  get '/' => 'players#root'
end
