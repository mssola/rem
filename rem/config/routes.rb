Rem::Application.routes.draw do
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'signup' => 'users#new', as: 'signup'
  get 'ajax_request' => 'users#ajax_request', as: 'ajax_request'
  get ':name' => "users#edit"
  root to: 'home#index'

  # Rest API
  get "/users/:name" => "users#show"

  resources :users, :sessions, :password_resets
end
