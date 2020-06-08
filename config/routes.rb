Rails.application.routes.draw do
  devise_for :users
  root 'toppage#index'
  resources :users, only: [:show]
end
