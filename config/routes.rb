
Rem::Application.routes.draw do

  scope :protocol => 'https://', :constraints => { :protocol => 'https://' } do
    resources :sessions
    resources :users, :except => [:show] # Rest API
  end
  # RESTful resources
  resources :password_resets, :places
#   resources :users, :except => [:show] # Rest API
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
  get '/places/id/:id' => 'places#edit', as: 'map_place'

  post '/ajax/update_places' => 'routes#update_places'

  post '/change_password' => 'password_resets#auth_change', as: 'auth_change'

  # Rest API: Android login
  post '/android' => 'sessions#android'

  # Rest API: Show info about users, routes and places.
  get "/users/:name" => "users#show"
  get "/routes/:name" => "routes#show"
  get "/places/:name" => "places#show"

  # Rest API: Upload/remove photos.
  post "/photos/:route_id" => "places#photos"
  delete "/photos/:place_id" => "places#delete_photos"

  # Rest API: Show the routes of the given user
  get "/users/:name/routes" => "users#routes", as: 'user_routes'

  # Rest API: Get nearby locations
  get "/places/nearby/:id" => "places#nearby"

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

  # Footer pages
  get '/about' => "home#about"
  get '/overview' => "home#overview"
  get '/contact' => "home#contact"
  get '/help' => "home#help"

  # API page
  resources :api, :only => [:index] do
    collection do
      get 'basics' => 'api#basics'
      get 'routes_places' => 'api#routes_places'
      get 'nearby' => 'api#nearby'
    end
  end

  # This is quite ugly though
  get "/:name/:route_id" => "routes#edit", as: 'edit_route', route_id: /\d+/

  # This is the last to be routed so we don't mess things up.
  get '/:name' => "users#edit"
end
