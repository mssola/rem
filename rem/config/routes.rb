
Rem::Application.routes.draw do
  # RESTful resources
  resources :users, :sessions, :password_resets, :routes, :places

  # Users, sessions and accounts
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'signup' => 'users#new', as: 'signup'
  get 'ajax_request' => 'users#ajax_request', as: 'ajax_request'
  get 'account' => 'account#edit', as: 'account'
  put 'account' => 'account#update'

  # OAuth paths
  match '/auth/failure' => "sessions#failure"
  match '/auth/:provider/callback' => 'sessions#create'

  # Home, sweet home :)
  root to: 'home#index'

  # Footer
  get '/about' => "home#about"
  get '/overview' => "home#overview"
  get '/contact' => "home#contact"
  get '/api' => "home#api"
  get '/help' => "home#help"

  # Rest API
  get "/users/:name" => "users#show"
  get "/routes/:name" => "routes#show"
  get "/places/:name" => "places#show"

  # This is the last to be routed so we don't mess things up.
  get '/:name' => "users#edit"
end
