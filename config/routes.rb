Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  get '/oauth_failure' => 'login#oauth_failure'

  resource :home, controller: :home, only: :index do
  end
  resources :songs, only: [:show, :update]
  resources :notebooks, only: [:new, :create, :destroy]
end
