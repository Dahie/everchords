# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers:
      { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'home#index'

  get '/oauth_failure' => 'login#oauth_failure'
  get 'imprint' => 'pages#imprint', as: 'imprint'
  get 'help' => 'pages#help', as: 'help'
  get 'health' => 'health#index', as: 'health'

  resource :home, controller: :home, only: :index
  resources :songs, only: %i[show update]
  get ':username', to: 'users#show', as: :user
  get ':username/:id', to: 'songs#show', as: :user_song
  resources :notebooks, only: %i[new create update destroy]
end
