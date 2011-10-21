Rem::Application.routes.draw do
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  get 'signup' => 'users#new', as: 'signup'
  get 'ajax_request' => 'users#ajax_request', as: 'ajax_request'
  get 'delete_account/:id' => 'users#destroy', as: 'delete_account'
  get 'account' => 'account#edit', as: 'account'
  put 'account' => 'account#update'

  # OAuth paths
  match '/auth/failure' => "sessions#failure"
  match '/auth/:provider/callback' => 'sessions#create'

  root to: 'home#index'

  # Footer
  get '/about' => "home#about"
  get '/overview' => "home#overview"
  get '/contact' => "home#contact"
  get '/api' => "home#api"
  get '/help' => "home#help"

  # Rest API
  get "/users/:name" => "users#show"

  resources :users, :sessions, :password_resets, :account, :routes

  get '/:name' => "users#edit"
end
