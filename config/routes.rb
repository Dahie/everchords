Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"

  get '/auth/:provider/callback' => 'login#callback'
  get '/logout' => 'login#logout', :as => 'logout'
  get '/oauth_failure' => 'login#oauth_failure'

  resource :home, controller: :home, only: :index do
  end
  resources :songs, only: :show
end
