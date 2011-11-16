
Rem::Application.routes.draw do
  # RESTful resources
  resources :sessions, :password_resets
  resources :users, :places, :except => [:show] # Rest API
  resources :routes, :except => [:show, :edit]
  resources :relationships, :only => [:create, :destroy]
  resources :route_relationships, :only => [:create, :destroy]

  # Users, sessions and accounts
  get 'login' => 'sessions#new', as: 'login'
  get 'logout' => 'sessions#destroy', as: 'logout'
  post '/search' => 'sessions#search', as: 'search'
  get 'signup' => 'users#new', as: 'signup'
  get 'ajax_request' => 'users#ajax_request', as: 'ajax_request'
  get 'account' => 'account#edit', as: 'account'
  put 'account' => 'account#update'

  # Rest API: Show info about users, routes and places.
  get "/users/:name" => "users#show"
  get "/routes/:name" => "routes#show"
  get "/places/:name" => "places#show"

  # Rest API: Upload/remove photos.
  post "/photos/:route_id" => "places#photos"
  delete "/photos/:route_id/:pname" => "places#delete_photos"

  # Rest API: Show the routes of the given user
  get "/users/:name/routes" => "users#routes", as: 'user_routes'

  # Following / followers
  get '/:name/:id/followers' => 'routes#followers', as: 'followers_route'
  get '/:name/following' => "users#following", as: 'following_user'
  get '/:name/followers' => "users#followers", as: 'followers_user'

  # OAuth paths
  controller :sessions do
    scope '/auth', as: 'auth' do
      match ':provider/callback' => :create
      match :failure
    end
  end

  # Home, sweet home :)
  root to: 'home#index'

  # Footer
  get '/about' => "home#about"
  get '/overview' => "home#overview"
  get '/contact' => "home#contact"
  get '/api' => "home#api"
  get '/help' => "home#help"

  # This is quite ugly though
  get "/:name/:route_id" => "routes#edit", as: 'edit_route', route_id: /\d+/

  # This is the last to be routed so we don't mess things up.
  get '/:name' => "users#edit"
end
