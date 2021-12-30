Rails.application.routes.draw do
  resources :players #, only: [:index]
  get  "/"  => "players#root"
end
