# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  get '/oauth_failure' => 'login#oauth_failure'

  resource :home, controller: :home, only: :index do
  end
  resources :songs, only: %i[show update]
  resources :notebooks, only: %i[new create update destroy]
  get 'imprint' => 'pages#imprint', as: 'imprint'
end
