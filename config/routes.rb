# frozen_string_literal: true

Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers:
      { omniauth_callbacks: 'users/omniauth_callbacks' }

  root to: 'home#index'

  get '/oauth_failure' => 'login#oauth_failure'

  resource :home, controller: :home, only: :index do
  end
  resources :songs, only: %i[show update]
  resources :notebooks, only: %i[new create update destroy]
  get 'imprint' => 'pages#imprint', as: 'imprint'
  get 'help' => 'pages#help', as: 'help'
end
